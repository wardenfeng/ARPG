export class LoginUI {
  private container: HTMLDivElement;
  private accountInput: HTMLInputElement;
  private passwordInput: HTMLInputElement;
  private loginButton: HTMLButtonElement;
  private onLoginCallback?: (account: string, password: string) => void;

  constructor() {
    this.container = document.createElement('div');
    this.container.style.cssText = `
      position: fixed;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      background: rgba(0, 0, 0, 0.8);
      padding: 30px;
      border-radius: 10px;
      color: white;
      font-family: Arial, sans-serif;
      z-index: 1000;
    `;

    const title = document.createElement('h2');
    title.textContent = 'ARPG Game Login';
    title.style.marginBottom = '20px';
    this.container.appendChild(title);

    this.accountInput = document.createElement('input');
    this.accountInput.type = 'text';
    this.accountInput.placeholder = 'Account';
    this.accountInput.style.cssText = `
      width: 200px;
      padding: 10px;
      margin: 10px 0;
      display: block;
      border: 1px solid #ccc;
      border-radius: 5px;
    `;
    this.container.appendChild(this.accountInput);

    this.passwordInput = document.createElement('input');
    this.passwordInput.type = 'password';
    this.passwordInput.placeholder = 'Password';
    this.passwordInput.style.cssText = `
      width: 200px;
      padding: 10px;
      margin: 10px 0;
      display: block;
      border: 1px solid #ccc;
      border-radius: 5px;
    `;
    this.container.appendChild(this.passwordInput);

    this.loginButton = document.createElement('button');
    this.loginButton.textContent = 'Login';
    this.loginButton.style.cssText = `
      width: 220px;
      padding: 10px;
      margin: 10px 0;
      background: #4CAF50;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      font-size: 16px;
    `;
    this.loginButton.onclick = () => {
      const account = this.accountInput.value.trim();
      const password = this.passwordInput.value.trim();
      if (account && password && this.onLoginCallback) {
        this.onLoginCallback(account, password);
      }
    };
    this.container.appendChild(this.loginButton);

    // Enter key support
    this.passwordInput.onkeypress = (e) => {
      if (e.key === 'Enter') {
        this.loginButton.click();
      }
    };
  }

  show(): void {
    document.body.appendChild(this.container);
    this.accountInput.focus();
  }

  hide(): void {
    if (this.container.parentNode) {
      this.container.parentNode.removeChild(this.container);
    }
  }

  setOnLogin(callback: (account: string, password: string) => void): void {
    this.onLoginCallback = callback;
  }
}

