Return-Path: <SRS0=bY9v=NN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E470C32789
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 16:52:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A0D92081B
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 16:52:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A0D92081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbeKCB7w (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Nov 2018 21:59:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:4129 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbeKCB7w (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 2 Nov 2018 21:59:52 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Nov 2018 09:52:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,456,1534834800"; 
   d="scan'208";a="276633999"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.193])
  by fmsmga005.fm.intel.com with ESMTP; 02 Nov 2018 09:52:03 -0700
Date:   Fri, 2 Nov 2018 09:52:04 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rich Felker <dalias@libc.org>, Jann Horn <jannh@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Florian Weimer <fweimer@redhat.com>,
        Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Carlos O'Donell <carlos@redhat.com>,
        "adhemerval.zanella@linaro.org" <adhemerval.zanella@linaro.org>
Subject: Re: RFC: userspace exception fixups
Message-ID: <20181102165204.GC7393@linux.intel.com>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <CAG48ez0vBqL0tyfWwmuc_cq+OAUoEi88=r+t6h64a-Fw8z59zA@mail.gmail.com>
 <20181101185225.GC5150@brightrain.aerifal.cx>
 <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
 <20181101193107.GE5150@brightrain.aerifal.cx>
 <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
 <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
 <20181102163034.GB7393@linux.intel.com>
 <7e14ee0e-ce15-1e88-7ae9-4d0f40cb3d84@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e14ee0e-ce15-1e88-7ae9-4d0f40cb3d84@fortanix.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181102165204.sDUd10tHRSqrHVAshBtckN2JHbzqqYXFPAy4mnPG3JA@z>

On Fri, Nov 02, 2018 at 04:37:10PM +0000, Jethro Beekman wrote:
> On 2018-11-02 09:30, Sean Christopherson wrote:
> >... The intended convention for EENTER is to have an ENCLU at the AEX target ...
> >
> >... to further enforce that the AEX target needs to be ENCLU.
> 
> Some SGX runtimes may want to use a different AEX target.

To what end?  Userspace gets no indication as to why the AEX occurred.
And if exceptions are getting transfered to userspace the trampoline
would effectively be handling only INTR, NMI, #MC and EPC #PF.
