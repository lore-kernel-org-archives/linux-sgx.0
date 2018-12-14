Return-Path: <SRS0=odJq=OX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0548C43387
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Dec 2018 15:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74A182070B
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Dec 2018 15:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730252AbeLNPEi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 14 Dec 2018 10:04:38 -0500
Received: from mga05.intel.com ([192.55.52.43]:10341 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729691AbeLNPEh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 14 Dec 2018 10:04:37 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Dec 2018 07:04:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,353,1539673200"; 
   d="scan'208";a="110400187"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by orsmga003.jf.intel.com with ESMTP; 14 Dec 2018 07:04:37 -0800
Date:   Fri, 14 Dec 2018 07:04:37 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Dr. Greg" <greg@enjellic.com>
Subject: Re: [RFC PATCH v2 4/4] x86/vdso: Add __vdso_sgx_enter_enclave() to
 wrap SGX enclave transitions
Message-ID: <20181214150436.GA23255@linux.intel.com>
References: <20181206221922.31012-1-sean.j.christopherson@intel.com>
 <20181206221922.31012-5-sean.j.christopherson@intel.com>
 <f2b7df05-20ef-ac16-fc99-258c39d84666@fortanix.com>
 <59c989a1-e699-9665-780f-6dd263f41ce4@intel.com>
 <f595c046-682c-0d4a-ce68-44d4634cedf2@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f595c046-682c-0d4a-ce68-44d4634cedf2@fortanix.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Dec 08, 2018 at 08:15:38AM +0000, Jethro Beekman wrote:
> On 2018-12-08 00:14, Dave Hansen wrote:
> >On 12/7/18 10:15 AM, Jethro Beekman wrote:
> >>This is not sufficient to support the Fortanix SGX ABI calling
> >>convention, which was designed to be mostly compatible with the SysV
> >>64-bit calling convention. The following registers need to be passed in
> >>to an enclave from userspace: RDI, RSI, RDX, R8, R9, R10. The following
> >>registers need to be passed out from an enclave to userspace: RDI, RSI,
> >>RDX, R8, R9.
> >
> >Are you asking nicely to change the new Linux ABI to be consistent with
> >your existing ABI?  Or, are you saying that the new ABI *must* be
> >compatible with this previous out-of-tree implementation?
> 
> What's being discussed here is one of the alternatives for SGX fault
> handling, meant to improve the current status quo of having to use a signal
> handler.
> 
> I'm merely providing a data point that the currently proposed solution is
> not sufficient to support current use of the (ring 3) ENCLU instruction. You
> might find this useful in determining whether proposed kernel features will
> actually be used by users, and in further developing this solution or other
> solutions to the fault handling issue.
> 
> If going with the vDSO solution, I think something with semantics closer to
> the actual instruction would be preferred, like the following:
> 
> notrace __attribute__((naked)) long __vdso_sgx_enclu_with_aep()
> {
> 	asm volatile(
> 		"	lea	2f(%%rip), %%rcx\n"
> 		"1:	enclu\n"
> 		"2:     ret\n"
> 		".pushsection .fixup, \"ax\" \n"
> 		"3:	jmp 2b\n"
> 		".popsection\n"
> 		_ASM_VDSO_EXTABLE_HANDLE(1b, 3b)
> 		:::
> 	);
> }

Part of me likes this idea, but it's a documentation nightmare since
it's a completely customer register ABI.  And the caller's exception
handling gets a bit weird since RAX implicitly defines whether or not
an exception occurred.  I also think there's value in making the vDSO
function callable from standard C.
