"""
Gemini AI Service - Integration with Google Generative AI
"""
import google.generativeai as genai
from typing import Optional, Dict, Any
import os
from dotenv import load_dotenv
from loguru import logger

load_dotenv()

# Configure Gemini API
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY", "")
genai.configure(api_key=GEMINI_API_KEY)

# Model configurations
MODELS = {
    "flash": "gemini-2.0-flash",      # Fast, lightweight tasks
    "pro": "gemini-2.0-flash",        # Complex analysis
    "default": "gemini-2.0-flash",
}


class GeminiService:
    """Service for interacting with Google Gemini AI"""

    def __init__(self):
        self.api_key = GEMINI_API_KEY

    async def generate_response(
        self,
        prompt: str,
        system_instruction: Optional[str] = None,
        model: str = "flash",
        temperature: float = 0.7,
        max_output_tokens: int = 2048,
    ) -> Dict[str, Any]:
        """
        Generate a response from Gemini AI.
        """
        try:
            model_name = MODELS.get(model, MODELS["default"])
            generative_model = genai.GenerativeModel(
                model_name=model_name,
                system_instruction=system_instruction,
            )

            generation_config = genai.types.GenerationConfig(
                temperature=temperature,
                max_output_tokens=max_output_tokens,
            )

            response = await generative_model.generate_content_async(
                prompt,
                generation_config=generation_config,
            )

            return {
                "text": response.text,
                "model": model_name,
                "tokens_used": response.usage_metadata.total_token_count if response.usage_metadata else 0,
            }

        except Exception as e:
            logger.error(f"Gemini API error: {e}")
            raise

    async def chat_with_context(
        self,
        message: str,
        chat_history: list[Dict[str, str]],
        system_instruction: str,
        user_context: Optional[Dict[str, Any]] = None,
    ) -> Dict[str, Any]:
        """
        Chat with Gemini using conversation history and user context.
        """
        try:
            model = genai.GenerativeModel(
                model_name=MODELS["flash"],
                system_instruction=system_instruction,
            )

            chat = model.start_chat(history=chat_history)

            # Add user context if provided
            if user_context:
                context_msg = f"User Context: {user_context}"
                message = f"{context_msg}\n\nUser Message: {message}"

            response = await chat.send_message_async(message)

            return {
                "text": response.text,
                "tokens_used": response.usage_metadata.total_token_count if response.usage_metadata else 0,
                "history": [msg.to_dict() for msg in chat.history],
            }

        except Exception as e:
            logger.error(f"Gemini chat error: {e}")
            raise


# Singleton instance
gemini_service = GeminiService()