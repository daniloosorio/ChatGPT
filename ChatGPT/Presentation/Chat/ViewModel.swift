//
//  ViewModel.swift
//  ChatGPT
//
//  Created by Danilo Osorio on 10/03/25.
//

import Foundation
import SwiftOpenAI


final class ViewModel: ObservableObject {
    @Published var messages: [MessageChatGPT] = [
        .init(text: "Hola en que puedo ayudarte...", role: .system)
    ]
    @Published var currentMessage: MessageChatGPT = . init(text: "", role: .assistant)
    var openAi = SwiftOpenAI(apiKey: "apikey")
    
    func send(message:String) async{
        // Define an array of MessageChatGPT objects representing the conversation.
        //let messages: [MessageChatGPT] = [
          // A system message to set the context or role of the assistant.
        //  MessageChatGPT(text: "Eres mi asistente de desarrollo de software Android e IOS", role: .system),
          // A user message asking a question.
       //   MessageChatGPT(text: "hola", role: .user)
       // ]

        // Define optional parameters for the chat completion request.
        let optionalParameters = ChatCompletionsOptionalParameters(
            temperature: 0.7, // Set the creativity level of the response.
            stream: true, // Enable streaming to get responses as they are generated.
            maxTokens: 50 // Limit the maximum number of tokens (words) in the response.
        )

        
        await MainActor.run {
            let myMessage = MessageChatGPT(text: message, role: .user)
            self.messages.append(myMessage)
            self.currentMessage = MessageChatGPT(text: "", role: .assistant)
            self.messages.append(self.currentMessage)
        }

        do {
            // Create a chat completion stream using the OpenAI API.
            let stream = try await openAi.createChatCompletionsStream(
                model: .gpt4o(.base), // Specify the model, here GPT-4 base model.
                messages: messages, // Provide the conversation messages.
                optionalParameters: optionalParameters // Include the optional parameters.
            )
            
            // Iterate over each response received in the stream.
            for try await response in stream {
                // Print each response as it's received.
                print(response)
                await onReceive(newMessage: response)
            }
        } catch {
            // Handle any errors encountered during the chat completion process.
            print("Error: \(error)")
        }
    }
    
    @MainActor
    private func onReceive(newMessage: ChatCompletionsStreamDataModel) {
        let lastMessage = newMessage.choices[0]
        guard lastMessage.finishReason == nil else {
            var size = messages.count
            print("finish stream message size: \(size)")
            return
        }
        
        guard let content = lastMessage.delta?.content else {
            print("message with no content")
            return
        }
        
        currentMessage.text = currentMessage.text + content
        messages[messages.count - 1].text = currentMessage.text
        
    }
}
