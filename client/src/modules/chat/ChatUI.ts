export class ChatUI {
  private container: HTMLDivElement;
  private messageList: HTMLDivElement;
  private input: HTMLInputElement;
  private sendButton: HTMLButtonElement;
  private onSendCallback?: (message: string) => void;

  constructor() {
    this.container = document.createElement('div');
    this.container.style.cssText = `
      position: fixed;
      bottom: 20px;
      left: 20px;
      width: 300px;
      background: rgba(0, 0, 0, 0.7);
      border-radius: 5px;
      padding: 10px;
      color: white;
      font-family: Arial, sans-serif;
      font-size: 12px;
      z-index: 100;
    `;

    this.messageList = document.createElement('div');
    this.messageList.style.cssText = `
      max-height: 200px;
      overflow-y: auto;
      margin-bottom: 10px;
      word-wrap: break-word;
    `;
    this.container.appendChild(this.messageList);

    const inputContainer = document.createElement('div');
    inputContainer.style.cssText = 'display: flex; gap: 5px;';

    this.input = document.createElement('input');
    this.input.type = 'text';
    this.input.placeholder = 'Type message...';
    this.input.style.cssText = `
      flex: 1;
      padding: 5px;
      border: 1px solid #ccc;
      border-radius: 3px;
      background: rgba(255, 255, 255, 0.9);
      color: black;
    `;
    inputContainer.appendChild(this.input);

    this.sendButton = document.createElement('button');
    this.sendButton.textContent = 'Send';
    this.sendButton.style.cssText = `
      padding: 5px 15px;
      background: #4CAF50;
      color: white;
      border: none;
      border-radius: 3px;
      cursor: pointer;
    `;
    this.sendButton.onclick = () => {
      const message = this.input.value.trim();
      if (message && this.onSendCallback) {
        this.onSendCallback(message);
        this.input.value = '';
      }
    };
    inputContainer.appendChild(this.sendButton);

    this.container.appendChild(inputContainer);

    // Enter key support
    this.input.onkeypress = (e) => {
      if (e.key === 'Enter') {
        this.sendButton.click();
      }
    };
  }

  show(): void {
    if (!document.body.contains(this.container)) {
      document.body.appendChild(this.container);
    }
  }

  hide(): void {
    if (this.container.parentNode) {
      this.container.parentNode.removeChild(this.container);
    }
  }

  addMessage(username: string, message: string): void {
    const messageElement = document.createElement('div');
    messageElement.style.cssText = 'margin: 5px 0;';
    messageElement.innerHTML = `<strong>${username}:</strong> ${message}`;
    this.messageList.appendChild(messageElement);
    
    // Auto scroll to bottom
    this.messageList.scrollTop = this.messageList.scrollHeight;
    
    // Limit message count
    while (this.messageList.children.length > 50) {
      this.messageList.removeChild(this.messageList.firstChild!);
    }
  }

  setOnSend(callback: (message: string) => void): void {
    this.onSendCallback = callback;
  }
}

