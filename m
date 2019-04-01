Return-Path: <SRS0=Wg/f=SD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C520C43381
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Apr 2019 10:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D85032086C
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Apr 2019 10:01:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbfDAKBs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Apr 2019 06:01:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:21796 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbfDAKBs (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 1 Apr 2019 06:01:48 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Apr 2019 03:01:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,296,1549958400"; 
   d="scan'208";a="136526709"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.96])
  by fmsmga008.fm.intel.com with ESMTP; 01 Apr 2019 03:01:43 -0700
Date:   Mon, 1 Apr 2019 13:01:42 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "haitao.huang@intel.com" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kai.svahn@intel.com" <kai.svahn@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "kai.huang@intel.com" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v19 16/27] x86/sgx: Add the Linux SGX Enclave Driver
Message-ID: <20190401100142.GB8483@linux.intel.com>
References: <20190319211951.GI25575@linux.intel.com>
 <20190321155111.GR4603@linux.intel.com>
 <20190326132650.GA31662@linux.intel.com>
 <20190326235852.GL3757@linux.intel.com>
 <20190327052830.GF15397@linux.intel.com>
 <825f5477-c90a-b54b-efeb-a1dc43ccc9d2@fortanix.com>
 <20190327200610.GF9310@linux.intel.com>
 <20190328131939.GI7094@linux.intel.com>
 <CALCETrXWMtm9WcPjbYB+ubRkb++WBYzYJAkiU-LJT_SK+m+SmQ@mail.gmail.com>
 <20190329162001.GC19448@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190329162001.GC19448@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 29, 2019 at 09:20:05AM -0700, Sean Christopherson wrote:
> On Thu, Mar 28, 2019 at 12:05:39PM -0700, Andy Lutomirski wrote:
> > On Thu, Mar 28, 2019 at 6:19 AM Jarkko Sakkinen
> > <jarkko.sakkinen@linux.intel.com> wrote:
> > >
> > > On Wed, Mar 27, 2019 at 01:06:11PM -0700, Sean Christopherson wrote:
> > > > I agree with all of the above, but unfortunately blacklisting is really
> > > > the only benefit that would be realized by modularizing the driver.  The
> > > > "driver" at this point is just the device and its ioctls, the meat of
> > > > the functionality has been moved into the subsystem proper.  And the few
> > > > remaining tidbits of functionality, e.g. sgx_encl_page_alloc() and
> > > > sgx_encl_alloc(), probably should be moved out of ioctl.c as well.
> > >
> > > That is kind of core reason of having an LKM here, to wrap the uapi. It
> > > is not about reducing size of the kernel. It is about ability to tailor
> > > the uapi on stock kernels.
> > >
> > 
> > As I see it, there is really only one significant benefit of modules:
> > reducing the size of the kernel in the case that the module isn't
> > loaded.
> 
> This is a much more succinct explanation of what I was attempting to say.
> 
> >  (And organizing module parameters, I suppose, but you don't,
> > strictly speaking, need to be able to build as a module to do that.)
> > SGX can be blacklisted by booting with nosgx (or, if if can't, then
> > that should be added).
> 
> The split lock detection series also proposed extending clearcpuid to
> take flags by name, a dedicated 'nosgx' may not even be necessary in the
> long run.
> 
> https://lkml.kernel.org/r/1549084491-57808-6-git-send-email-fenghua.yu@intel.com
> https://lkml.kernel.org/r/1549084491-57808-7-git-send-email-fenghua.yu@intel.com
> https://lkml.kernel.org/r/1549084491-57808-8-git-send-email-fenghua.yu@intel.com

OK, that's great. Then I just rework the LKM out...

/Jarkko
