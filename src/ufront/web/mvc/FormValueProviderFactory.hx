package ufront.web.mvc;
import thx.error.NullArgument;
import ufront.web.mvc.ControllerContext;
import ufront.web.mvc.IValueProvider;

/**
 * ...
 * @author Andreas Soderlund
 */

class FormValueProviderFactory extends ValueProviderFactory
{
	public function new() 
	{
		super();
	}
	
	override public function getValueProvider(controllerContext : ControllerContext) : IValueProvider 
	{
		NullArgument.throwIfNull(controllerContext, "controllerContext");		
		return new FormValueProvider(controllerContext);
	}
}