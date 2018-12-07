Return-Path: <SRS0=sJTe=OQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06599C07E85
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Dec 2018 19:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B17912083D
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Dec 2018 19:02:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B17912083D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbeLGTC6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 7 Dec 2018 14:02:58 -0500
Received: from mga17.intel.com ([192.55.52.151]:59689 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbeLGTC6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 7 Dec 2018 14:02:58 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Dec 2018 11:02:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,327,1539673200"; 
   d="scan'208";a="97025170"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by orsmga007.jf.intel.com with ESMTP; 07 Dec 2018 11:02:57 -0800
Date:   Fri, 7 Dec 2018 11:02:57 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-sgx@vger.kernel.org, haitao.huang@linux.intel.com,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr. Greg Wettstein" <greg@enjellic.com>
Subject: Re: [RFC PATCH v2 4/4] x86/vdso: Add __vdso_sgx_enter_enclave() to
 wrap SGX enclave transitions
Message-ID: <20181207190257.GC10404@linux.intel.com>
References: <20181206221922.31012-1-sean.j.christopherson@intel.com>
 <20181206221922.31012-5-sean.j.christopherson@intel.com>
 <CALCETrXRJ645=08fyeoMQ949fLB1TvhsgERFVx5mAHdViEjq8Q@mail.gmail.com>
 <20181207165145.GB10404@linux.intel.com>
 <CALCETrVkEW82PzQZhJ5iS849DLY1gbd8YjH5F7P1J7hgjkjiOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVkEW82PzQZhJ5iS849DLY1gbd8YjH5F7P1J7hgjkjiOQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 07, 2018 at 09:56:09AM -0800, Andy Lutomirski wrote:
> On Fri, Dec 7, 2018 at 8:51 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> > I like that the exit handler allows userspace to trap/panic with the full
> > call stack in place, and in a dedicated path, i.e. outside of the basic
> > enter/exit code.  An exit handler probably doesn't fundamentally change
> > what userspace can do with respect to debugging/reporting, but I think
> > it would actually simplify some userspace implementations, e.g. I'd use
> > it in my tests like so:
> >
> > long fault_handler(struct sgx_enclave_exit_info *exit_info, void *tcs, void *priv)
> > {
> >         if (exit_info->leaf == SGX_EEXIT)
> >                 return 0;
> >
> >         <report exception and die/hang>
> > }
> >
> 
> Hmm.  That't not totally silly, although you could accomplish almost
> the same thing by wrapping the vDSO helper in another function.

True, but I think there's value in having the option to intercept an
exception at the exact(ish) point of failure, without having to return
up the stack.

The enclave has full access to the process' memory space, including the
untrsuted stack.  It's not too far fetched to envision a scenario where
the enclave corrupts the stack even if the enclave isn't intentionally
using the stack, e.g. the host passes in variable that a points at the
stack instead of whatever memory is supposed to be shared between the
enclave and host.  It'd be nice to have the ability to triage something
like that without having to e.g. configure breakpoints on the stack.
