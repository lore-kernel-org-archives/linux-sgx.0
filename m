Return-Path: <SRS0=odJq=OX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1C8C43387
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Dec 2018 15:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 836D2206C0
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Dec 2018 15:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbeLNPib (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 14 Dec 2018 10:38:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:39031 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbeLNPib (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 14 Dec 2018 10:38:31 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Dec 2018 07:38:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,353,1539673200"; 
   d="scan'208";a="118579296"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Dec 2018 07:38:30 -0800
Date:   Fri, 14 Dec 2018 07:38:30 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [RFC PATCH v4 5/5] x86/vdso: Add __vdso_sgx_enter_enclave() to
 wrap SGX enclave transitions
Message-ID: <20181214153830.GB22063@linux.intel.com>
References: <20181213213135.12913-1-sean.j.christopherson@intel.com>
 <20181213213135.12913-6-sean.j.christopherson@intel.com>
 <cda13cff-1a56-a40f-7d69-f0f1ab752f8e@fortanix.com>
 <20181214151204.GA22063@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181214151204.GA22063@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 14, 2018 at 07:12:04AM -0800, Sean Christopherson wrote:
> On Fri, Dec 14, 2018 at 09:55:49AM +0000, Jethro Beekman wrote:
> > On 2018-12-14 03:01, Sean Christopherson wrote:
> > >+2:	pop	%rbx
> > >+	pop	%r12
> > >+	pop	%r13
> > >+	pop	%r14
> > >+	pop	%r15
> > >+	pop	%rbp
> > >+	ret
> > 
> > x86-64 ABI requires that you call CLD here (enclave may set it).
> 
> Ugh.  Technically MXCSR and the x87 CW also need to be preserved.
> 
> What if rather than treating the enclave as hostile we require it to be
> compliant with the x86-64 ABI like any other function?  That would solve
> the EFLAGS.DF, MXCSR and x87 issues without adding unnecessary overhead.
> And we wouldn't have to save/restore R12-R15.  It'd mean we couldn't use
> the stack's red zone to hold @regs and @e, but that's poor form anyways.

Grr, except the processor crushes R12-R15, FCW and MXCSR on asynchronous
exits.  But not EFLAGS.DF, that's real helpful.
