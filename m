From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v14 11/19] x86/sgx: Add wrappers for ENCLS leaf functions
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, <x86@kernel.org>,
	<platform-driver-x86@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <linux-sgx@vger.kernel.org>,
	<andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter
 Anvin" <hpa@zytor.com>, Suresh Siddha <suresh.b.siddha@intel.com>, "open
 list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
 <20180925130845.9962-12-jarkko.sakkinen@linux.intel.com>
Message-ID: <a2d77169-5c14-10f0-425f-41e37f791ece@infradead.org>
Date: Tue, 25 Sep 2018 13:01:47 -0700
In-Reply-To: <20180925130845.9962-12-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Sender: <platform-driver-x86-owner@vger.kernel.org>
Return-Path: platform-driver-x86-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On 9/25/18 6:06 AM, Jarkko Sakkinen wrote:
> Add wrappers for Intel(R) SGX ENCLS opcode leaf functions except
> ENCLS(EINIT). ENCLS invokes privileged functions for managing (creation,
> initialization and swapping) and debugging enclaves.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/sgx.h | 244 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 244 insertions(+)
> 
> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> index f4f82f0453a9..e66e2572011e 100644
> --- a/arch/x86/include/asm/sgx.h
> +++ b/arch/x86/include/asm/sgx.h
> @@ -10,4 +10,248 @@
>  extern bool sgx_enabled;
>  extern bool sgx_lc_enabled;
>  

Hi,
Please don't use "/**" to begin comment blocks that are not kernel-doc
notation, like the 3 below.  Note: I might have seen one (or some) of
these "fixed" in other patches in this series (not sure).


> +/**
> + * ENCLS_FAULT_FLAG - flag signifying an ENCLS return code is a trapnr
> + *
> + * ENCLS has its own (positive value) error codes and also generates
> + * ENCLS specific #GP and #PF faults.  And the ENCLS values get munged
> + * with system error codes as everything percolates back up the stack.
> + * Unfortunately (for us), we need to precisely identify each unique
> + * error code, e.g. the action taken if EWB fails varies based on the
> + * type of fault and on the exact SGX error code, i.e. we can't simply
> + * convert all faults to -EFAULT.
> + *
> + * To make all three error types coexist, we set bit 30 to identify an
> + * ENCLS fault.  Bit 31 (technically bits N:31) is used to differentiate
> + * between positive (faults and SGX error codes) and negative (system
> + * error codes) values.
> + */
> +#define ENCLS_FAULT_FLAG 0x40000000
> +
> +/**
> + * Check for a fault by looking for a postive value with the fault
> + * flag set.  The postive value check is needed to filter out system
> + * error codes since negative values will have all higher order bits
> + * set, including ENCLS_FAULT_FLAG.
> + */
> +#define IS_ENCLS_FAULT(r) ((int)(r) > 0 && ((r) & ENCLS_FAULT_FLAG))
> +
> +/**
> + * Retrieve the encoded trapnr from the specified return code.
> + */
> +#define ENCLS_TRAPNR(r) ((r) & ~ENCLS_FAULT_FLAG)

thanks,
-- 
~Randy
