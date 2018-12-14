Return-Path: <SRS0=odJq=OX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E08A0C43387
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Dec 2018 19:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FF3C204FD
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Dec 2018 19:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730508AbeLNTUK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 14 Dec 2018 14:20:10 -0500
Received: from mga04.intel.com ([192.55.52.120]:57754 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730414AbeLNTUK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 14 Dec 2018 14:20:10 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Dec 2018 11:20:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,354,1539673200"; 
   d="scan'208";a="118898537"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by orsmga001.jf.intel.com with ESMTP; 14 Dec 2018 11:20:09 -0800
Date:   Fri, 14 Dec 2018 11:20:09 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [RFC PATCH v4 5/5] x86/vdso: Add __vdso_sgx_enter_enclave() to
 wrap SGX enclave transitions
Message-ID: <20181214192009.GE22063@linux.intel.com>
References: <20181213213135.12913-1-sean.j.christopherson@intel.com>
 <20181213213135.12913-6-sean.j.christopherson@intel.com>
 <cda13cff-1a56-a40f-7d69-f0f1ab752f8e@fortanix.com>
 <20181214151204.GA22063@linux.intel.com>
 <20181214153830.GB22063@linux.intel.com>
 <20181214170310.GC22063@linux.intel.com>
 <90D05734-1583-4306-A9A4-18E4A1390F3B@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <90D05734-1583-4306-A9A4-18E4A1390F3B@amacapital.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 14, 2018 at 10:44:10AM -0800, Andy Lutomirski wrote:
> 
> > On Dec 14, 2018, at 9:03 AM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > 
> > .pushsection .fixup, "ax"
> > 2:    pop    %rcx    
> >    test    %rcx, %rcx
> >    je    3f
> > 
> >    mov    %eax, EX_LEAF(%rcx)
> >    mov    %di,  EX_TRAPNR(%rcx)
> >    mov    %si,  EX_ERROR_CODE(%rcx)
> >    mov    %rdx, EX_ADDRESS(%rcx)
> > 3:    mov     $(-EFAULT), %rax
> >    ret
> 
> I’m not totally sold on -EFAULT as the error code.  That usually
> indicates a bad pointer.  I’m not sure I have a better suggestion.

Hmm, one idea would be to return positive signal numbers, e.g. SIGILL
for #UD.  I don't like that approach though as it adds a fair amount
of code to the fixup handler for dubious value, e.g. userspace would
still need to check the exception error code to determine if the EPC
is lost.  And we'd have to update the vDSO if a new exception and/or
signal was added, e.g. #CP for CET.

Encapsulating "you faulted" in a single error code seems cleaner for
both kernel and userspace code, and -EFAULT makes that pretty obvious
even though we're bastardizing its meaning a bit.

In general, I'd prefer to return only 0 or negative values so that
userspace can easily merge in their own (positive value) error codes
from the enclave, e.g. in the vDSO wrapper:

    /* Enclave's return value is in RDI, overwrite RAX on success */
    test    %rax, %rax
    cmove   %rdi, %rax
    ret 
