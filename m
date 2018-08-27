Received: from mga05.intel.com ([192.55.52.43]:8423 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S1727218AbeH1BEk (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Mon, 27
 Aug 2018 21:04:40 -0400
Subject: Re: [PATCH v13 09/13] x86/sgx: Enclave Page Cache (EPC) memory
 manager
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, <x86@kernel.org>,
	<platform-driver-x86@vger.kernel.org>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-10-jarkko.sakkinen@linux.intel.com>
CC: <sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin"
	<hpa@zytor.com>, Suresh Siddha <suresh.b.siddha@intel.com>, Serge Ayoun
	<serge.ayoun@intel.com>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <7c5df14e-3028-46b3-fe93-aa6ba8352317@intel.com>
Date: Mon, 27 Aug 2018 14:15:34 -0700
In-Reply-To: <20180827185507.17087-10-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On 08/27/2018 11:53 AM, Jarkko Sakkinen wrote:
> +struct sgx_epc_page_ops {
> +	bool (*get)(struct sgx_epc_page *epc_page);
> +	void (*put)(struct sgx_epc_page *epc_page);
> +	bool (*reclaim)(struct sgx_epc_page *epc_page);
> +	void (*block)(struct sgx_epc_page *epc_page);
> +	void (*write)(struct sgx_epc_page *epc_page);
> +};

Why do we need a fancy, slow (retpoline'd) set of function pointers when
we only have one user of these (the SGX driver)?
