Return-Path: <SRS0=sJTe=OQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A4CC07E85
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Dec 2018 16:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7184C2081C
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Dec 2018 16:51:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7184C2081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbeLGQvr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 7 Dec 2018 11:51:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:8825 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbeLGQvq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 7 Dec 2018 11:51:46 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Dec 2018 08:51:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,326,1539673200"; 
   d="scan'208";a="96986161"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by orsmga007.jf.intel.com with ESMTP; 07 Dec 2018 08:51:45 -0800
Date:   Fri, 7 Dec 2018 08:51:45 -0800
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
        linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr. Greg" <greg@enjellic.com>
Subject: Re: [RFC PATCH v2 4/4] x86/vdso: Add __vdso_sgx_enter_enclave() to
 wrap SGX enclave transitions
Message-ID: <20181207165145.GB10404@linux.intel.com>
References: <20181206221922.31012-1-sean.j.christopherson@intel.com>
 <20181206221922.31012-5-sean.j.christopherson@intel.com>
 <CALCETrXRJ645=08fyeoMQ949fLB1TvhsgERFVx5mAHdViEjq8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXRJ645=08fyeoMQ949fLB1TvhsgERFVx5mAHdViEjq8Q@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

+Cc: linux-sgx, Haitao, Greg and Jethro

My apologies for neglecting to cc the SGX folks, original thread is here:

https://lkml.kernel.org/r/20181206221922.31012-1-sean.j.christopherson@intel.com

On Thu, Dec 06, 2018 at 02:50:01PM -0800, Andy Lutomirski wrote:
> On Thu, Dec 6, 2018 at 2:19 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
>  +
> > +       /*
> > +        * Invoke the caller's exit handler if one was provided.  The return
> > +        * value tells us whether to re-enter the enclave (EENTER or ERESUME)
> > +        * or to return (EEXIT).
> > +        */
> > +       if (exit_handler) {
> > +               leaf = exit_handler(exit_info, tcs, priv);
> > +               if (leaf == SGX_EENTER || leaf == SGX_ERESUME)
> > +                       goto enter_enclave;
> > +               if (leaf == SGX_EEXIT)
> > +                       return 0;
> > +               return -EINVAL;
> > +       } else if (leaf != SGX_EEXIT) {
> > +               return -EFAULT;
> > +       }
> 
> This still seems overcomplicated to me.  How about letting the
> requested leaf (EENTER or ERESUME) be a parameter to the function and
> then just returning here?  As it stands, you're requiring any ERESUME
> that gets issued (other than the implicit ones) to be issued in the
> same call stack, which is very awkward if you're doing something like
> forwarding the fault to a different task over a socket and then
> waiting in epoll_wait() or similar before resuming the enclave.

Ah, yeah, wasn't thinking about usage models where the enclave could
get passed off to a different thread.

What about supporting both, i.e. keep the exit handler but make it 100%
optional?  And simplify the exit_handler to effectively return a boolean,
i.e. "exit or continue".

Something like this:

notrace long __vdso_sgx_enter_enclave(u32 op, void *tcs, void *priv,
				      struct sgx_enclave_exit_info *exit_info,
				      sgx_enclave_exit_handler *exit_handler)
{
	u64 rdi, rsi, rdx;
	u32 leaf;
	long ret;

	if (!tcs || !exit_info)
		return -EINVAL;

enter_enclave:
	if (op != SGX_EENTER && op != SGX_ERESUME)
		return -EINVAL;

        <same core code>

	/*
	 * Invoke the caller's exit handler if one was provided.  The return
	 * value tells us whether to re-enter the enclave (EENTER or ERESUME)
	 * or to return (EEXIT).
	 */
	if (exit_handler) {
		if (exit_handler(exit_info, tcs, priv)) {
			op = exit_info->leaf;
			goto enter_enclave;
		}
	}

	if (exit_info->leaf == SGX_EEXIT)
		return -EFAULT;

	return 0;
}


I like that the exit handler allows userspace to trap/panic with the full
call stack in place, and in a dedicated path, i.e. outside of the basic
enter/exit code.  An exit handler probably doesn't fundamentally change
what userspace can do with respect to debugging/reporting, but I think
it would actually simplify some userspace implementations, e.g. I'd use
it in my tests like so:

long fault_handler(struct sgx_enclave_exit_info *exit_info, void *tcs, void *priv)
{
	if (exit_info->leaf == SGX_EEXIT)
		return 0;

	<report exception and die/hang>
}

