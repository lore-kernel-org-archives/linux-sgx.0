Return-Path: <SRS0=gKhM=SY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32ED4C10F11
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Apr 2019 17:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07B3220684
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Apr 2019 17:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbfDVRRQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 22 Apr 2019 13:17:16 -0400
Received: from mga04.intel.com ([192.55.52.120]:48829 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbfDVRRQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 22 Apr 2019 13:17:16 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Apr 2019 10:17:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,382,1549958400"; 
   d="scan'208";a="339751353"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by fmsmga006.fm.intel.com with ESMTP; 22 Apr 2019 10:17:15 -0700
Date:   Mon, 22 Apr 2019 10:17:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Dr. Greg" <greg@enjellic.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
Message-ID: <20190422171714.GE1236@linux.intel.com>
References: <444537E3-4156-41FB-83CA-57C5B660523F@amacapital.net>
 <f9d93291-9b59-7b66-de9f-af92246f1c9c@fortanix.com>
 <alpine.DEB.2.21.1904192337160.3174@nanos.tec.linutronix.de>
 <5854e66a-950e-1b12-5393-d9cdd15367dc@fortanix.com>
 <alpine.DEB.2.21.1904200727410.3174@nanos.tec.linutronix.de>
 <20190420160247.GA17291@wind.enjellic.com>
 <20190422150119.GA1236@linux.intel.com>
 <20190422162411.GA27389@wind.enjellic.com>
 <20190422164827.GC1236@linux.intel.com>
 <CAHk-=wjmT=uC1=18ZYV1CMfP_FBUEjh9_rabH0g+a0z-L0cgHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjmT=uC1=18ZYV1CMfP_FBUEjh9_rabH0g+a0z-L0cgHg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 22, 2019 at 09:55:47AM -0700, Linus Torvalds wrote:
> On Mon, Apr 22, 2019 at 9:48 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Right, and loading a malicious enclave doesn't change those guarantees
> > (for other enclaves).  Ergo, restricting which enclaves can execute is
> > orthogonal to the security provided by SGX.
> 
> But it is absolutely worth noting that TSX made a lot of attacks both
> easier to _do_, and also easier to _hide_.
> 
> All while being basically completely worthless technology to everybody
> except for some silly SAP benchmark.
> 
> So it is definitely worth at least discussing the downsides of SGX. If
> it ends up being another technology that makes it easier to create
> malware, without actually having a lot of _good_ software use it, the
> patches to enable it should make damn sure that the upsides actually
> outweigh the downsides.
> 
> And if the current setup basically is "you have to disable reasonable
> SElinux protections that lots of distros use today", I think it's
> entirely reasonable saying "the downsides are bigger than the
> upsides".

I'm not arguing against SGX playing nice with SELinux/LSMs, actually the
opposite.  I completely agree that enclaves should be subject to LSM
restrictions.

AIUI, Dr. Greg is proposing a framework that uses SGX's launch control
mechanism to restrict what enclaves can run.  My point is that restricting
what enclaves can run is about protecting the kernel and/or platform, not
the enclaves themselves, i.e. using launch control instead of, or in
addition to, LSMs doesn't change the security guarantees of SGX.
