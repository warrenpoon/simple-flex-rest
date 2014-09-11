package com.warrenpoon.simpleflexrest
{
	import flash.events.Event;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	
	/**
	 * Singleton class for invoking REST operations
	 */	
	public class ServiceInvoker
	{
		private static var _instance:ServiceInvoker;
		
		/**
		 * A proxy is necessary for PUT, DELETE, etc operations that Flex HTTPService does not support (only can do POST and GET).
		 * Just create a simple script in your preferred language that accepts the desired URL, payload, and method via HTTP POST.
		 */
		private static const PROXY_URL:String = "https://<yourserver.com>/<proxy.php>";
		
		
		public static function getInstance():ServiceInvoker {
			if(!_instance) {
				_instance = new ServiceInvoker();
			}
			return _instance;
		}
		
		private function faultHandler(e:Event):void {
			trace("ServiceInvoker ERROR: " + e.toString());	
			throw e;
		}
		
		/**
		 * The result handler is passed in as a parameter.
		 */
		public function getOperation(url:String, callback:Function, faultHandler:Function=null):void {
			try {

				var svc:HTTPService = new HTTPService( url );
				svc.addEventListener( ResultEvent.RESULT, callback );
				if( faultHandler != null ) {
					svc.addEventListener( FaultEvent.FAULT, faultHandler );
				}
				else {
					svc.addEventListener( FaultEvent.FAULT, this.faultHandler );
				}
				svc.method = "GET";
				svc.url = url;
				svc.send();
				
			}
			catch(e:Error) {
				trace(e.getStackTrace().toString());
			}
		}
		
		
		
		/**
		 * Allows user to send a generic Object stdclass payload to POST resource.
		 */
		public function postOperation(url:String, payloadJSON:String, callback:Function, faultHandler:Function=null):void {
			try {
				var svc:HTTPService = new HTTPService(url);
				svc.addEventListener(ResultEvent.RESULT, callback);
				if( faultHandler != null ) {
					svc.addEventListener(FaultEvent.FAULT, faultHandler);
				}
				else {
					svc.addEventListener(FaultEvent.FAULT, this.faultHandler);
				}
				svc.url = url;
				svc.method = "POST";
				svc.contentType = "application/json";  
				svc.headers = "{ Accept: application/json }";
				svc.send(payloadJSON);
			}
			catch(e:Error) {
				trace(e.getStackTrace().toString());
			}
		}
		
		
		
		
		
		/**
		 * Since Flex doesn't do GET/POST, we need to use a PHP proxy.  
		 */
		public function deleteOperation(url:String, callback:Function, faultHandler:Function=null):void {
			try {
				
				var svc:HTTPService = new HTTPService(url);
				svc.addEventListener(ResultEvent.RESULT, callback);
				if( faultHandler != null ) {
					svc.addEventListener(FaultEvent.FAULT, faultHandler);
				}
				else {
					svc.addEventListener(FaultEvent.FAULT, this.faultHandler);
				}
				var payload:String = "{\"url\":\""+url+"\", \"method\":\"DELETE\"}";
				svc.url = PROXY_URL;
				svc.method = "POST";
				svc.contentType = "application/json";  
				svc.headers = "{ Accept: application/json }";
				svc.send(payload);
			}
			catch(e:Error) {
				trace(e.getStackTrace().toString());
			}
		}
		
		
		
		public function putOperation(url:String, payload:String, callback:Function, faultHandler:Function=null):void {
			try {
				
				var svc:HTTPService = new HTTPService(url);
				svc.addEventListener(ResultEvent.RESULT, callback);
				if( faultHandler != null ) {
					svc.addEventListener(FaultEvent.FAULT, faultHandler);
				}
				else {
					svc.addEventListener(FaultEvent.FAULT, this.faultHandler);
				}
				var request:String = "{\"url\":\""+url+"\", \"method\":\"PUT\", \"payload\": \"" + payload + "\"}";
				svc.url = PROXY_URL; 
				svc.method = "POST";
				svc.contentType = "application/json";  
				svc.headers = "{ Accept: application/json }";
				svc.send(request);
			}
			catch(e:Error) {
				trace(e.getStackTrace().toString());
			}
		}
	}
	
}
