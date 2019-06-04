Return-Path: <SRS0=DpJx=UD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D55C282CE
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 12:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 472CA23E96
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 12:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfFDMYz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Jun 2019 08:24:55 -0400
Received: from mga12.intel.com ([192.55.52.136]:32822 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727409AbfFDMYy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 4 Jun 2019 08:24:54 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 05:24:54 -0700
X-ExtLoop1: 1
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.189])
  by fmsmga001.fm.intel.com with ESMTP; 04 Jun 2019 05:24:47 -0700
Date:   Tue, 4 Jun 2019 15:24:47 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Cedric Xing <cedric.xing@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, nhorman@redhat.com,
        npmccallum@redhat.com, Serge Ayoun <serge.ayoun@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Haitao Huang <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kai Svahn <kai.svahn@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Kai Huang <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        William Roberts <william.c.roberts@intel.com>,
        Philip Tricca <philip.b.tricca@intel.com>
Subject: Re: [RFC PATCH 4/9] mm: Introduce vm_ops->mprotect()
Message-ID: <20190604122447.GE30594@linux.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-5-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531233159.30992-5-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 31, 2019 at 04:31:54PM -0700, Sean Christopherson wrote:
> SGX will use the mprotect() hook to prevent userspace from circumventing
> various security checks, i.e. Linux Security Modules.
> 
> Enclaves are built by copying data from normal memory into the Enclave
> Page Cache (EPC).  Due to the nature of SGX, the EPC is represented by a
> single file that must be MAP_SHARED, i.e. mprotect() only ever sees a
> single MAP_SHARED vm_file.  Furthermore, all enclaves will need read,
> write and execute pages in the EPC.

What does the last sentence is pointing out? Enclaves read, write and
execute pages, so?

> As a result, LSM policies cannot be meaningfully applied, e.g. an LSM
> can deny access to the EPC as a whole, but can't deny PROT_EXEC on page
> that originated in a non-EXECUTE file (which is long gone by the time
> mprotect() is called).

I'm not sure what kind of scenario this is describing where some LSM
can't dent PROT_EXEC. Kind of cryptic paragraph, have to say.

> By hooking mprotect(), SGX can make explicit LSM upcalls while an
> enclave is being built, i.e. when the kernel has a handle to origin of
> each enclave page, and enforce the result of the LSM policy whenever
> userspace maps the enclave page in the future.

How does mprotect() enabled adding new LSM hooks?

> Alternatively, SGX could play games with MAY_{READ,WRITE,EXEC}, but
> that approach is quite ugly, e.g. would require userspace to call an
> SGX ioctl() prior to using mprotect() to extend a page's protections.

Not really sure I got this. SGX gets page permissions in SECINFO.
Also recurring comment about MAY_* constants.

> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  include/linux/mm.h |  2 ++
>  mm/mprotect.c      | 15 +++++++++++----
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 0e8834ac32b7..50a42364a885 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -458,6 +458,8 @@ struct vm_operations_struct {
>  	void (*close)(struct vm_area_struct * area);
>  	int (*split)(struct vm_area_struct * area, unsigned long addr);
>  	int (*mremap)(struct vm_area_struct * area);
> +	int (*mprotect)(struct vm_area_struct * area, unsigned long start,
> +			unsigned long end, unsigned long prot);

Right, the hook must be here obviously because mprotect() can be called
when /dev/sgx/enclave is closed. Can you describe start and end i.e.
what range they are in?

>  	vm_fault_t (*fault)(struct vm_fault *vmf);
>  	vm_fault_t (*huge_fault)(struct vm_fault *vmf,
>  			enum page_entry_size pe_size);
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index bf38dfbbb4b4..e466ca5e4fe0 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -547,13 +547,20 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
>  			goto out;
>  		}
>  
> -		error = security_file_mprotect(vma, reqprot, prot);
> -		if (error)
> -			goto out;
> -
>  		tmp = vma->vm_end;
>  		if (tmp > end)
>  			tmp = end;
> +
> +		if (vma->vm_ops && vma->vm_ops->mprotect) {
> +			error = vma->vm_ops->mprotect(vma, nstart, tmp, prot);
> +			if (error)
> +				goto out;
> +		}
> +
> +		error = security_file_mprotect(vma, reqprot, prot);

Why is mprotect callback called post the LSM hook?

> +		if (error)
> +			goto out;

/Jarkko
