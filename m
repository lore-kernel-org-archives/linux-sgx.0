Return-Path: <SRS0=lIZr=OU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A1E3C07E85
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Dec 2018 14:56:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C0EE2082F
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Dec 2018 14:56:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C0EE2082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=enjellic.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbeLKO4h (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 11 Dec 2018 09:56:37 -0500
Received: from wind.enjellic.com ([76.10.64.91]:56764 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbeLKO4h (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 11 Dec 2018 09:56:37 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id wBBEre8E008223;
        Tue, 11 Dec 2018 08:53:40 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id wBBErdTu008222;
        Tue, 11 Dec 2018 08:53:39 -0600
Date:   Tue, 11 Dec 2018 08:53:39 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [RFC PATCH v3 0/4] x86: Add exception fixup for SGX ENCLU
Message-ID: <20181211145339.GA7528@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20181210232141.5425-1-sean.j.christopherson@intel.com> <20181210232449.GA11843@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181210232449.GA11843@localhost>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Tue, 11 Dec 2018 08:53:40 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 10, 2018 at 03:24:50PM -0800, Josh Triplett wrote:

Good morning to everyone, I hope the week is progressing well.

> On Mon, Dec 10, 2018 at 03:21:37PM -0800, Sean Christopherson wrote:
> > At that point I realized it's a hell of a lot easier to simply provide
> > an IOCTL via /dev/sgx that allows userspace to register a per-process
> > ENCLU exception handler.  At a high level, the basic idea is the same
> > as the vDSO approach: provide a hardcoded fixup handler for ENCLU and
> > attempt to fixup select unhandled exceptions that occurred in user code.

> So, on the one hand, this is *absolutely* much cleaner than the VDSO
> approach. On the other hand, this is global process state and has
> some of the same problems as a signal handler as a result.

Sean's architecture is very simple and straight forward and thus has a
lot going for it.

As Sean's approach indicates, by linking the exception handler to
current->mm, SGX is very much a per memory map concept.  The issue is
that there can be multiple enclaves loaded and excecuting in a
processes memory map, the problem is, execution and thus exception
handling, is very much at the per thread level.

Based on the responses to my previous e-mail in this thread, the
primary driver for addressing the exception handler issue is for
shared libraries to implement independent execution of enclaves.  So
the question for Sean becomes where the 'pull' to address this issue
is coming from, is it the Intel SDK/PSW folks?  If so it might be
helpful for them to weigh in on requirements and needs.

To be very frank, there are only 3-4 groups actually working at this
level; the Intel SDK/PSW team, Fortanix, us and probably Baidu.  Given
the complexity of the issues involved with a runtime, the Linux SGX
development community, whether it be application or library developers
are going to be building on top of runtimes maintained by groups such
as these.

If we boil issues down to the very basics, the setup of an exception
handler is going to have to be wrapped into whatever code is being
executed by a thread doing enclave entry for the runtime being used.
It thus may be useful to think about this as being the responsibility
of whatever loaded and initialized the enclave against which
ENCLU[EENTER] is being issued against.

To add an additional wrinkle to this, our runtime is already doing
what amounts to recursive enclave invocation.  We handle remote
attestation quote generation and verification almost completely inside
of enclaves.  This requires that we issue an OCALL in order to exit
the enclave being attested in order to load and execute the platform
certification and quoting enclaves.

So if Linux is going to deal with this correctly, without invoking any
global state, the issue will come down conceptually to registering a
per-thread/per-EENTER exception handler by whatever mechanism the
kernel chooses to provide.  Which means we need to be thinking about
the ramifications of OCALL's.

So whatever we do has to be simple, straight forward and flexible.  If
not the bike shedding will last until something other then SGX gets
invented... :-)

I hope the above reflections are useful.

Best wishes for a productive day.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"If your doing something the same way you have been doing it for ten years,
 the chances are you are doing it wrong."
                                -- Charles Kettering
