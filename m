Return-Path: <SRS0=YVcv=UJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C468AC31E40
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 15:06:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2D1C20859
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 15:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391057AbfFJPGS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Jun 2019 11:06:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:38253 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389368AbfFJPGS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Jun 2019 11:06:18 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jun 2019 08:06:17 -0700
X-ExtLoop1: 1
Received: from agusev-mobl.ger.corp.intel.com (HELO localhost) ([10.249.46.248])
  by fmsmga006.fm.intel.com with ESMTP; 10 Jun 2019 08:06:05 -0700
Date:   Mon, 10 Jun 2019 18:06:00 +0300
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
Subject: Re: [RFC PATCH v2 1/5] mm: Introduce vm_ops->may_mprotect()
Message-ID: <20190610150600.GA3752@linux.intel.com>
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
 <20190606021145.12604-2-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606021145.12604-2-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 05, 2019 at 07:11:41PM -0700, Sean Christopherson wrote:
> SGX will use the may_mprotect() hook to prevent userspace from
> circumventing various security checks, e.g. Linux Security Modules.
> Naming it may_mprotect() instead of simply mprotect() is intended to
> reflect the hook's purpose as a way to gate mprotect() as opposed to
> a wholesale replacement.

"This commit adds may_mprotect() to struct vm_operations_struct, which
can be used to ask from the owner of a VMA if mprotect() is allowed."

This would be more appropriate statement because that is what the code
change aims for precisely. I did not even understand what you meant by
gating in this context. I would leave SGX and LSM's (and especially
"various security checks", which means abssolutely nothing) out of the
first paragraph completely.

> Enclaves are built by copying data from normal memory into the Enclave
> Page Cache (EPC).  Due to the nature of SGX, the EPC is represented by a
> single file that must be MAP_SHARED, i.e. mprotect() only ever sees a
> MAP_SHARED vm_file that references single file path.  Furthermore, all
> enclaves will need read, write and execute pages in the EPC.

I would just say that "Due to the fact that EPC is delivered as IO
memory from the preboot firmware, it can be only mapped as MAP_SHARED".
It is what it is.

> As a result, LSM policies cannot be meaningfully applied, e.g. an LSM
> can deny access to the EPC as a whole, but can't deny PROT_EXEC on page
> that originated in a non-EXECUTE file (which is long gone by the time
> mprotect() is called).

I have hard time following what is paragraph is trying to say.

> By hooking mprotect(), SGX can make explicit LSM upcalls while an
> enclave is being built, i.e. when the kernel has a handle to origin of
> each enclave page, and enforce the result of the LSM policy whenever
> userspace maps the enclave page in the future.

"LSM policy whenever calls mprotect()"? I'm no sure why you mean by
mapping here and if there is any need to talk about future. Isn't this
needed now?

> Alternatively, SGX could play games with MAY_{READ,WRITE,EXEC}, but
> that approach is quite ugly, e.g. would require userspace to call an
> SGX ioctl() prior to using mprotect() to extend a page's protections.

Instead of talking "playing games" I would state what could be done with
VM_MAY{READ,WRITE,EXEC} and why it is bad. Leaves questions otherwise.

> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  include/linux/mm.h |  2 ++
>  mm/mprotect.c      | 15 +++++++++++----
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 0e8834ac32b7..a697996040ac 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -458,6 +458,8 @@ struct vm_operations_struct {
>  	void (*close)(struct vm_area_struct * area);
>  	int (*split)(struct vm_area_struct * area, unsigned long addr);
>  	int (*mremap)(struct vm_area_struct * area);
> +	int (*may_mprotect)(struct vm_area_struct * area, unsigned long start,
> +			    unsigned long end, unsigned long prot);

Could be just boolean.

/Jarkko
