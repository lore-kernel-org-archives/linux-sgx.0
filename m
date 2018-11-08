Return-Path: <SRS0=tPzl=NT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCDD2ECDE4B
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Nov 2018 15:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CEE52081D
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Nov 2018 15:04:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8CEE52081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbeKIAkN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Nov 2018 19:40:13 -0500
Received: from mga14.intel.com ([192.55.52.115]:13569 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbeKIAkN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Nov 2018 19:40:13 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2018 07:04:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,480,1534834800"; 
   d="scan'208";a="106544802"
Received: from ibanaga-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.75])
  by orsmga001.jf.intel.com with ESMTP; 08 Nov 2018 07:04:06 -0800
Date:   Thu, 8 Nov 2018 17:04:05 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rich Felker <dalias@libc.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
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
Message-ID: <20181108150405.GB14072@linux.intel.com>
References: <CALCETrV=iodOQhvXAyjs0TQNbCaFdkhrZqRHvWTnBfo2m0qXpA@mail.gmail.com>
 <1541541565.8854.13.camel@intel.com>
 <7FF4802E-FBC5-4E6D-A8F6-8A65114F18C7@amacapital.net>
 <20181106233515.GB11101@linux.intel.com>
 <CALCETrVySfV64YN7DWf3rsAxfiugJKsRJCNmEn-AKQ4dPYeG4Q@mail.gmail.com>
 <20181107000235.GC11101@linux.intel.com>
 <CALCETrV_sMOeQGRkxoA8KMxEizagB9bD-mB2T-ro3F6O6OX9Xw@mail.gmail.com>
 <20181107153452.GB22972@linux.intel.com>
 <20181107190114.GA26603@linux.intel.com>
 <662fa2c8-c9a8-b2a8-ee8b-92a8a89c0630@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <662fa2c8-c9a8-b2a8-ee8b-92a8a89c0630@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181108150405.etnBteszKftQRXNGQFpgR67VbwLrkShqu0nuQaRmDTo@z>

On Wed, Nov 07, 2018 at 12:56:58PM -0800, Dave Hansen wrote:
> On 11/7/18 11:01 AM, Sean Christopherson wrote:
> > Going off comments in similar code related to UMIP, we'd need to figure
> > out how to handle protection keys.
> 
> There are two options:
> 1. Don't depend on the userspace mapping.  Do get_user_pages() to find
>    the instruction in the kernel direct map, and use that.
> 2. Do a WRPKRU that allows read access, do the read, then put PKRU back.
>    This is a pain because of preemption and all that jazz.
> 
> Right now, we just let the prefetch instruction detection fail if you
> mark it unreadable with pkeys.  Tough cookies, basically.  But, that's
> just the kernel being nice, but you need it for functionality, so it's
> tougher.

I would go with one because it is the stable way to do it and we are
100% sure to not conflict with pk's.

/Jarkko
