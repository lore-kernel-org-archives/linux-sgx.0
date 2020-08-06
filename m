Return-Path: <SRS0=kl42=BQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C63C43445
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 11:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE06A22D07
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 11:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbgHFK6I (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 6 Aug 2020 06:58:08 -0400
Received: from wind.enjellic.com ([76.10.64.91]:50922 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729333AbgHFKhV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 6 Aug 2020 06:37:21 -0400
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Aug 2020 06:35:34 EDT
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 076ALnK6015337;
        Thu, 6 Aug 2020 05:21:49 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 076ALmaH015336;
        Thu, 6 Aug 2020 05:21:48 -0500
Date:   Thu, 6 Aug 2020 05:21:48 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v36 23/24] docs: x86/sgx: Document SGX micro architecture and kernel internals
Message-ID: <20200806102148.GA14798@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com> <20200716135303.276442-24-jarkko.sakkinen@linux.intel.com> <20200728213511.GB13081@duo.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728213511.GB13081@duo.ucw.cz>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Thu, 06 Aug 2020 05:21:49 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jul 28, 2020 at 11:35:11PM +0200, Pavel Machek wrote:

> Hi!

Good morning, I hope the week is progressing well for everyone.

> > CPUs starting from Icelake use Total Memory Encryption (TME) in
> > the place of MEE. TME throws away the Merkle tree, which means
> > losing integrity and anti-replay protection but also enables
> > variable size memory pools for EPC.  Using this attack for
> > benefit would require an interposer on the system bus.

> It is not exactly clear what "this attack" means.

In the new world that is SGX, 'this attack', roughly means that
enclaves are susceptible to the same security threats that would be
faced if you were running TLS/HTTPS or SSH without packet checksums
and replay avoidance/detection mechanisms in place.

It is extremely unfortunate to the nascent field of confidential
computing that an option was not made available to the platform owner
to choose between full and partial security.  The decision to opt for
partial security only, significantly limits the utility of this
technology for architects who are serious about the ability to push
applications into the 'cloud', or other environments without direct
physical control, with an expectation that it will be running in an
'island' of confidentiality or security.

> (And it would be cool to explain against what SGX is protecting. I
> thought it was malicious RAM, but apparently not on Icelake+).

The best way to understand the implications of all this is to review
the following paper:

https://eprint.iacr.org/2016/204.pdf

It is the canonical and very thorough description of the Memory
Encryption Engine (MEE) by its designer Shay Gueron.  Shay is notable
in that he led the development of the Intel hardware AES architecture
including the 'shuffle' instructions that make it possible.

As would be expected for a scientific paper on security, it has a full
description of the threat model that the MEE was designed to address
and mathematical proofs of its correctness in doing so.  Absent its
implementation, the 'new' SGX is vulnerable to the threats described
in that paper.

This ultimately calls into question what the Confidential Computing
Initiative (CCI) actually represents.  The question to be answered is
whether or not one believes that encryption without integrity is an
acceptable security architecture.

One can make a perfectly legitimate argument, which Jarkko notes, in
that an adversary has to control the physical hardware.  A very candid
assessment is that the CCI is predicated on the notion of providing
protection in an environment where you push your computation and data
into an environment where an adversary has both the access and ability
to mount an attack.

There are certainly economic issues driving these decisions.  Which is
ultimately a statement on the actual and very difficult inherency
barriers that security innovation and advancement faces.

> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Hopefully the above is helpful and informative to those who are
interested in these types of issues.

Best wishes for a productive remainder of the week.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686            EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"We can't solve today's problems by using the same thinking we used in
 creating them."
                                -- Einstein
