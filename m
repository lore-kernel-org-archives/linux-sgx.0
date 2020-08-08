Return-Path: <SRS0=6V3N=BS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B16C433E0
	for <linux-sgx@archiver.kernel.org>; Sat,  8 Aug 2020 22:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2098F20716
	for <linux-sgx@archiver.kernel.org>; Sat,  8 Aug 2020 22:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgHHWSM convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 8 Aug 2020 18:18:12 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:37752 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgHHWSM (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 8 Aug 2020 18:18:12 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C848E1C0BD9; Sun,  9 Aug 2020 00:18:09 +0200 (CEST)
Date:   Sun, 9 Aug 2020 00:18:08 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     "Dr. Greg" <greg@enjellic.com>
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
Subject: Re: [PATCH v36 23/24] docs: x86/sgx: Document SGX micro architecture
 and kernel internals
Message-ID: <20200808221808.GB1020@bug>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-24-jarkko.sakkinen@linux.intel.com>
 <20200728213511.GB13081@duo.ucw.cz>
 <20200806102148.GA14798@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200806102148.GA14798@wind.enjellic.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi!

> Good morning, I hope the week is progressing well for everyone.
> 
> > > CPUs starting from Icelake use Total Memory Encryption (TME) in
> > > the place of MEE. TME throws away the Merkle tree, which means
> > > losing integrity and anti-replay protection but also enables
> > > variable size memory pools for EPC.  Using this attack for
> > > benefit would require an interposer on the system bus.
> 
> > It is not exactly clear what "this attack" means.
> 
> In the new world that is SGX, 'this attack', roughly means that
> enclaves are susceptible to the same security threats that would be
> faced if you were running TLS/HTTPS or SSH without packet checksums
> and replay avoidance/detection mechanisms in place.

Umm, ssh w/o checksums would be rather dangerous, no? As in... if I can guess what you
are typing, I can make you type something else.

Anyway, it would be nice to somehow fix the document. It talks about "this attack"
without talking about any attack before, which is bad style.

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
