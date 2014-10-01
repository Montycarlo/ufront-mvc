/**
 * ...
 * @author Franco Ponticelli
 */

package neko.ufront.web.context;

import thx.sys.Lib;
import thx.error.Error;

using StringTools;

class HttpResponse extends ufront.web.context.HttpResponse {
	public function new() {
		super();
		_init();
	}

	override function flush() {
		if ( _flushed )
			return;

		_flushed = true;
		
		// Set HTTP status code
		_set_return_code( status );

		// Set Cookies
		try {
			for ( cookie in _cookies ) {
				var description = cookie.description;
				 var name = cookie.name;
				_set_cookie( untyped name.__s, untyped description.__s );
			}
		}
		catch ( e:Dynamic ) {
			throw new Error( 'Cannot flush cookies on response, output already sent: $e' );
		}

		// Write headers
		for ( key in _headers.keys() ) {
			var val = _headers.get(key);
			if ( key=="Content-type" && null!=charset && val.startsWith('text/') ) {
				val += "; charset=" + charset;
			}
			try {
				_set_header( untyped key.__s, untyped val.__s );
			}
			catch ( e:Dynamic ) {
				throw new Error( "Invalid header: '{0}: {1}', or output already sent", [key,val] );
			}
		}

		// Write response content
		Lib.print( _buff.toString() );
	}

	static var _set_header : Dynamic;
	static var _set_cookie : Dynamic;
	static var _set_return_code : Dynamic;
	static var _inited = false;

	static function _init() {
		if(_inited)
			return;
		_inited = true;
		var get_env = Lib.load( "std", "get_env", 1 );
		var ver = untyped get_env( "MOD_NEKO".__s );
		var lib = "mod_neko" + if ( ver==untyped "1".__s ) "" else ver;
		_set_header = Lib.load( lib, "set_header", 2 );
		_set_cookie = Lib.load( lib, "set_cookie", 2 );
		_set_return_code = Lib.load( lib, "set_return_code", 1 );
	}
}
