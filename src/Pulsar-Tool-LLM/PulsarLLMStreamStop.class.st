"
I am a private signal used to stop the OpenCode server-sent-events subscription once a session turn has ended.

I am raised inside the event block of PulsarLLMOpenCodeAPI>>sendText:toSession:kinds:do: and caught locally so that the underlying stream is closed by its ensure block.
"
Class {
	#name : 'PulsarLLMStreamStop',
	#superclass : 'Error',
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}
