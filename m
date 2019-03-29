Return-Path: <SRS0=i6Eh=SA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D7BC4360F
	for <linux-sgx@archiver.kernel.org>; Fri, 29 Mar 2019 09:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC56620693
	for <linux-sgx@archiver.kernel.org>; Fri, 29 Mar 2019 09:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbfC2Jnw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 29 Mar 2019 05:43:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:43289 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728415AbfC2Jnw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 29 Mar 2019 05:43:52 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Mar 2019 02:43:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,284,1549958400"; 
   d="scan'208";a="218707045"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.156])
  by orsmga001.jf.intel.com with ESMTP; 29 Mar 2019 02:43:46 -0700
Date:   Fri, 29 Mar 2019 11:43:46 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
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
Message-ID: <20190329094346.GD21379@linux.intel.com>
References: <20190317211456.13927-17-jarkko.sakkinen@linux.intel.com>
 <20190319211951.GI25575@linux.intel.com>
 <20190321155111.GR4603@linux.intel.com>
 <20190326132650.GA31662@linux.intel.com>
 <20190326235852.GL3757@linux.intel.com>
 <20190327052830.GF15397@linux.intel.com>
 <825f5477-c90a-b54b-efeb-a1dc43ccc9d2@fortanix.com>
 <20190327200610.GF9310@linux.intel.com>
 <20190328131939.GI7094@linux.intel.com>
 <CALCETrXWMtm9WcPjbYB+ubRkb++WBYzYJAkiU-LJT_SK+m+SmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXWMtm9WcPjbYB+ubRkb++WBYzYJAkiU-LJT_SK+m+SmQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 28, 2019 at 12:05:39PM -0700, Andy Lutomirski wrote:
> On Thu, Mar 28, 2019 at 6:19 AM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > On Wed, Mar 27, 2019 at 01:06:11PM -0700, Sean Christopherson wrote:
> > > I agree with all of the above, but unfortunately blacklisting is really
> > > the only benefit that would be realized by modularizing the driver.  The
> > > "driver" at this point is just the device and its ioctls, the meat of
> > > the functionality has been moved into the subsystem proper.  And the few
> > > remaining tidbits of functionality, e.g. sgx_encl_page_alloc() and
> > > sgx_encl_alloc(), probably should be moved out of ioctl.c as well.
> >
> > That is kind of core reason of having an LKM here, to wrap the uapi. It
> > is not about reducing size of the kernel. It is about ability to tailor
> > the uapi on stock kernels.
> >
> 
> As I see it, there is really only one significant benefit of modules:
> reducing the size of the kernel in the case that the module isn't
> loaded.  (And organizing module parameters, I suppose, but you don't,
> strictly speaking, need to be able to build as a module to do that.)
> SGX can be blacklisted by booting with nosgx (or, if if can't, then
> that should be added).

That would be for me a feasible solution that I could live with and it
could be also used to disable all of SGX. Thanks.

/Jarkko
