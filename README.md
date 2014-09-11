simple-flex-rest
=================

Simple REST/JSON abilities for ActionScript and Flex projects. Allows you to specify callbacks when making REST-style async operations via mx|HTTPService.

Example:

private function callback(e:ResultEvent):void {
	trace(e.result.toString());
}

private function invokeGetOperation():void {

	var uri:String = "http://yourserver.com/things";

	ServiceInvoker.getInstance().getOperation(uri, this.callback);	
}

private function invokePostOperation():void {
	
	var uri:String = "http://yourserver.com/things";
	var payload:String = "{ \"id\": 1, \"name\": \"Warren\" }";

	ServiceInvoker.getInstance().postOperation(uri, payload, this.callback);		
}