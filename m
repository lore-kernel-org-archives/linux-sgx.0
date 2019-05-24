Return-Path: <SRS0=Nb5J=TY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD5C2C072B5
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 17:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD7842133D
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 17:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbfEXRzA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 24 May 2019 13:55:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:52047 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727842AbfEXRzA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 24 May 2019 13:55:00 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 May 2019 10:54:59 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga007.fm.intel.com with ESMTP; 24 May 2019 10:54:58 -0700
Date:   Fri, 24 May 2019 10:54:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Message-ID: <20190524175458.GB365@linux.intel.com>
References: <CALCETrUS8xyF1JJmQs18BGTDhPRXf+s81BkMZCZwmY73r7M+zg@mail.gmail.com>
 <20190523023517.GA31950@linux.intel.com>
 <20190523102628.GC10955@linux.intel.com>
 <20190523141752.GA12078@linux.intel.com>
 <CALCETrUzx3LPAKCLFf75P-XshAkRcr+JLET3LA_kHDs9MA11FA@mail.gmail.com>
 <20190523234044.GC12078@linux.intel.com>
 <CALCETrV4DVEfW6EJ6DnQGGYDJAiA5M1QcuYJTiroumOM+D6Jjg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E8956@ORSMSX116.amr.corp.intel.com>
 <dda0912b-cb15-3c07-d368-345159e995f7@tycho.nsa.gov>
 <20190524174243.GA365@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524174243.GA365@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 24, 2019 at 10:42:43AM -0700, Sean Christopherson wrote:
> Hmm, I've been thinking more about pulling permissions from the source
> page.  Conceptually I'm not sure we need to meet the same requirements as
> non-enclave DSOs while the enclave is being built, i.e. do we really need
> to force userspace to fully map the enclave in normal memory?
>  
> Consider the Graphene scenario where it's building an enclave on the fly.
> Pulling permissions from the source VMAs means Graphene has to map the
> code pages of the enclave with X.  This means Graphene will need EXEDMOD
> (or EXECMEM if Graphene isn't careful).  In a non-SGX scenario this makes
> perfect sense since there is no way to verify the end result of RW->RX.
> 
> But for SGX, assuming enclaves are whitelisted by their sigstruct (checked
> at EINIT) and because page permissions affect sigstruct.MRENCLAVE, it *is*
> possible to verify the resulting RX contents.  E.g. for the purposes of
> LSMs, can't we use the .sigstruct file as a proxy for the enclave and
> require FILE__EXECUTE on the .sigstruct inode to map/run the enclave?
> 
> Stephen, is my logic sound?
> 
> 
> If so...
> 
>   - Require FILE__READ+FILE__EXECUTE on .sigstruct to mmap() the enclave.
> 
>   - Prevent userspace from mapping the enclave with permissions beyond the
>     original permissions of the enclave.  This can be done by populating
>     VM_MAY{READ,WRITE,EXEC} from the SECINFO (same basic concept as Andy's
>     proposals).  E.g. pre-EINIT, mmap() and mprotect() can only succeed
>     with PROT_NONE.
> 
>   - Require FILE__{READ,WRITE,EXECUTE} on /dev/sgx/enclave for simplicity,
>     or provide an alternate SGX_IOC_MPROTECT if we want to sidestep the
>     FILE__WRITE requirement.

One more thought.  EADD (and the equivalent SGX2 flow) could do
security_mmap_file() with a NULL file on the SECINFO permissions, which
would trigger PROCESS_EXECMEM if an enclave attempts to map a page RWX.

> No changes are required to LSMs, SGX1 has a single LSM touchpoint in its
> mmap(), and I *think* the only required userspace change is to mmap()
> PROT_NONE when allocating the enclave's virtual address range.
> 
> As for Graphene, it doesn't need extra permissions to run its enclaves,
> it just needs a way to install .sigstruct, which is a generic permissions
> problem and not SGX specific.
> 
> 
> For SGX2 maybe:
> 
>   - No additional requirements to map an EAUG'd page as RW page.  Not
>     aligned with standard MAP_SHARED behavior, but we really don't want
>     to require FILE__WRITE, and thus allow writes to .sigstruct. 
>  
>   - Require FILE__EXECMOD on the .sigstruct to map previously writable
>     page as executable (which indirectly includes all EAUG'd pages).
>     Wiring this up will be a little funky, but we again we don't want
>     to require FILE__WRITE on .sigstruct.
> 
