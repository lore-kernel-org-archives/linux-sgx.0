Return-Path: <SRS0=eliZ=NU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 642A5C43441
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Nov 2018 07:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2894D20840
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Nov 2018 07:13:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W5/yu3nF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2894D20840
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbeKIQwW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 9 Nov 2018 11:52:22 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:40018 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbeKIQwV (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 9 Nov 2018 11:52:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IrgHHScUgWiQ+RbIbd2HbhtIi//KRrdsNGy7S15z2dc=; b=W5/yu3nFZikOEofUR/GtmZxIv
        cT/aY4DO+LS2Diy1ebZVnAxEI6Ftzofd2PsUW9Q4iOooZa36wtU4MW+ZH7mpxr6WSnEmCuIhY6yt0
        SlTLazUYUTWffh5j+o0pFcebkwORwQurVTNNswO5/U/H/HYV8tj6pok1l5uKf1jRbXAxSpgkBB/zR
        yrpq5OPLBoZY4XaMWyXwSxtPqrQGhk6MiiR60kfbL/EZXu2jAaIJn/A1ALTAJjwsWVAtHD6MmBBAm
        +LpuZpNE+6XNdV4GhaI6IbMfnxdM865PFPHQZjb1ip2D6TB2wM/XpJdWktPVyEY3jaLxT50dJxhNs
        dqY/Go4JA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gL0yR-0004Qz-Mc; Fri, 09 Nov 2018 07:12:59 +0000
Date:   Thu, 8 Nov 2018 23:12:59 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rich Felker <dalias@libc.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Florian Weimer <fweimer@redhat.com>,
        Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com,
        npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Carlos O'Donell <carlos@redhat.com>,
        adhemerval.zanella@linaro.org
Subject: Re: RFC: userspace exception fixups
Message-ID: <20181109071259.GA14784@infradead.org>
References: <1541524750.7839.51.camel@intel.com>
 <22596E35-F5D1-4935-86AB-B510DCA0FABE@amacapital.net>
 <c9659222-efc6-b73a-ce48-30be8bdc5397@intel.com>
 <CALCETrWBV=1JbAKYn2Jy2LxkGZQvKRtFRnrWUMoejrwQe73VHw@mail.gmail.com>
 <b9c53669-cd27-e3bc-3d62-f47c77029c43@intel.com>
 <1C426267-492F-4AE7-8BE8-C7FE278531F9@amacapital.net>
 <209cf4a5-eda9-2495-539f-fed22252cf02@intel.com>
 <9B76E95B-5745-412E-8007-7FAA7F83D6FB@amacapital.net>
 <20181108195420.GA14715@linux.intel.com>
 <CALCETrUCQbPMfBJVRRg=0apEU=2U2ps74UPTrN8bFqi1k0K4VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUCQbPMfBJVRRg=0apEU=2U2ps74UPTrN8bFqi1k0K4VA@mail.gmail.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181109071259.IcwU-noO6nniPwCrnZQEiugiuaFWWzCcdWoUJhuuuzQ@z>

On Thu, Nov 08, 2018 at 12:05:42PM -0800, Andy Lutomirski wrote:
> This whole thing is a mess.  I'm starting to think that the cleanest
> solution would be to provide a way to just tell the kernel that
> certain RIP values have exception fixups.

The bay far cleanest solution would be to say that SGX is sich a mess
that we are not going to support it at all.  It's not like it is a must
have a feature to start with.
