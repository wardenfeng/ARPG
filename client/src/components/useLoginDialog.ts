import { ref, Ref } from 'vue';

export function useLoginDialog(emit: (event: 'login', account: string, password: string) => void) {
  const account: Ref<string> = ref('');
  const password: Ref<string> = ref('');
  const loading: Ref<boolean> = ref(false);
  const errorMessage: Ref<string> = ref('');

  const handleLogin = async (): Promise<void> => {
    if (loading.value || !account.value || !password.value) {
      return;
    }

    loading.value = true;
    errorMessage.value = '';

    try {
      emit('login', account.value.trim(), password.value.trim());
    } catch (error) {
      errorMessage.value = '登录失败，请重试';
    } finally {
      // 延迟重置 loading，让父组件处理登录结果
      setTimeout(() => {
        loading.value = false;
      }, 2000);
    }
  };

  return {
    account,
    password,
    loading,
    errorMessage,
    handleLogin,
  };
}
