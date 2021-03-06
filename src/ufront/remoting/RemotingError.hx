package ufront.remoting;

/**
A RemotingError describes different possible reasons that a Haxe/Ufront remoting call may fail.
It allows you to provide more fine grained error-recovery or error reporting.
**/
enum RemotingError<FailureType> {
	/** The HttpError gave a response code other than 200. **/
	RHttpError( remotingCallString:String, responseCode:Int, responseData:String );
	/** The server did not have an API or method matching the remoting call, or it was not shared in the remoting context. **/
	RApiNotFound( remotingCallString:String, errorMessage:String );
	/** The Server threw an exception during the remoting call. **/
	RServerSideException( remotingCallString:String, e:Dynamic, stack:String );
	/** The Client threw an exception while executing the callback for the remoting call. **/
	RClientCallbackException( remotingCallString:String, e:Dynamic );
	/** The result sent from the server could not be unserialized by the client.  Often this is due to the server and client having different versions of a particular class that are not compatible. **/
	RUnserializeFailed( remotingCallString:String, troubleLine:String, err:String );
	/** A response was received, but no remoting response line (beginning with "hxr") was found. **/
	RNoRemotingResult( remotingCallString:String, responseData:String );
	/** The remoting API was expected to return an `Outcome` or `Surprise`, and it did - it returned a Failure containing some data. (Note: The API and remoting mechanism functioned correctly). **/
	RApiFailure( remotingCallString:String, data:FailureType );
	/** An unknown error occured. **/
	RUnknownException( e:Dynamic );
}
