package ufront.view;

import haxe.ds.StringMap;
import Map;
using StringTools;

/**
	A trampoline type for TemplateData, accepting, in order:

	- {}
	- Map<String,Dynamic>
	- Iterable<TemplateData>
	
	These methods are provided to access or modify the contents of the template data:

	- `get()`
	- `set()`
	- `setObject()`
	- `setMap()`

	Array access is also provided for getting / setting data.

	No string conversion or escaping happens at this level, that is up to the templating engine.
**/
abstract TemplateData({}) to {} {
	
	inline function new( obj:{} )
		this = obj;

	/**
		Convert into a `Dynamic<Dynamic>` anonymous object.
		Please note this is not an implicit `@:to` cast, because the resulting type would match too many false positives.
		To use this cast call `templateData.toObject()` explicitly.
	**/
	public inline function toObject():Dynamic<Dynamic>
		return this;

	/**
		Convert into a `Map<String,Dynamic>`.
		This is also available as an implicit `@:to` cast.
	**/
	@:to public function toMap():Map<String,Dynamic> {
		var ret = new Map<String,Dynamic>();
		for ( k in Reflect.fields(this) ) ret[k] = Reflect.field( this, k );
		return ret;
	}

	/**
		Convert into a `StringMap<Dynamic>`.
		This is also available as an implicit `@:to` cast.
	**/
	@:to public inline function toStringMap():Map<String,Dynamic> {
		return toMap();
	}

	/**
		Get a value from the template data.
		This is also used for array access: `templateData['name']` is the same as `templateData.get('name')`.

		@param key The name of the value to retrieve.
		@return The value, or null if it was not available.
	**/
	@:arrayAccess public inline function get( key:String ):Null<Dynamic> return Reflect.field( this, key );
	
	/**
		Set a value on the template data.

		Please note array setters are also available, but they use the private `array_set` method which returns the value, rather than the TemplateData object.

		@param key The name of the key to set.
		@param val The value to set.
		@return The same TemplateData so that method chaining is enabled.
	**/
	public function set( key:String, val:Dynamic ):TemplateData {
		Reflect.setField( this, key, val );
		return new TemplateData( this );
	}

	/** Array access setter. **/
	@:arrayAccess function array_set<T>( key:String, val:T ):T {
		Reflect.setField( this, key, val );
		return val;
	}

	/**
		Set many values from a `Map<String,Dynamic>`

		`templateData.set(key,map[key])` will be called for each pair in the map.

		@param map The map data to set.
		@return The same TemplateData so that method chaining is enabled.
	**/
	public function setMap<T>( map:Map<String,T> ):TemplateData {
		for ( k in map.keys() ) {
			set( k, map[k] );
		}
		return new TemplateData( this );
	}

	/**
		Set many values from a `Map<String,Dynamic>`

		`templateData.set(fieldName,fieldValue)` will be called for each field on the object.

		Reflect is used with `fields` and `field` to read the value of every field.

		@param map The data object to set.
		@return The same TemplateData so that method chaining is enabled.
	**/
	public function setObject( d:{} ):TemplateData {
		for ( k in Reflect.fields(d) ) set( k, Reflect.field(d,k) );
		return new TemplateData( this );
	}

	/** from casts **/

	/**
		Automatically cast from a `Map<String,Dynamic>` into a TemplateData.
	**/
	@:from public static function fromMap<T>( d:Map<String,T> ):TemplateData {
		var m:TemplateData = new TemplateData( {} );
		m.setMap( d );
		return m;
	}

	/**
		Automatically cast from a `StringMap<Dynamic>` into a TemplateData.
	**/
	@:from public static inline function fromStringMap<T>( d:StringMap<T> ):TemplateData {
		return fromMap( d );
	}

	/**
		Automatically cast from a `Iterable<TemplateData>` into a combined `TemplateData.
		Values will be added in order, and later values with the same name as an earlier value will override the earlier value.
		If the iterable is empty, the resulting TemplateData will contain no properties.
		If an individual item is a StringMap, it will be added with `setMap`, otherwise it will be added with `setObject`.

		@param dataSets The collection of TemplateData objects to iterate over.
		@return The same TemplateData so that method chaining is enabled.
	**/
	@:from public static function fromMany( dataSets:Iterable<TemplateData> ):TemplateData {
		var combined:TemplateData = new TemplateData( {} );
		for ( d in dataSets ) {
			if ( Std.is(d,StringMap) ) {
				var map:StringMap<Dynamic> = cast d;
				combined.setMap( (map:StringMap<Dynamic>) );
			}
			else {
				var obj:Dynamic = d;
				combined.setObject( obj );
			}
		}
		return combined;
	}

	/**
		Automatically cast from an object to a TemplateData.
		This is a no-op - the object will be used as is.
		This cast comes last in the code so it should be used only if none of the other casts were utilised.
	**/
	@:from public static inline function fromObject( d:{} ):TemplateData {
		return new TemplateData( d );
	}
}
