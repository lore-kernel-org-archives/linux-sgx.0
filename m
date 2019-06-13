Return-Path: <SRS0=rpH8=UM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73974C31E45
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 19:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48EA920896
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 19:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfFMTQB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Jun 2019 15:16:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:50014 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbfFMTQA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Jun 2019 15:16:00 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 12:16:00 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga006.jf.intel.com with ESMTP; 13 Jun 2019 12:15:59 -0700
Date:   Thu, 13 Jun 2019 12:15:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [PATCH 4/7] x86/sgx: Allow userspace to add multiple pages in
 single ioctl()
Message-ID: <20190613191559.GA18385@linux.intel.com>
References: <20190605194845.926-1-sean.j.christopherson@intel.com>
 <20190605194845.926-5-sean.j.christopherson@intel.com>
 <f2e88e83-e5f6-fecb-c180-b75be1d1a582@fortanix.com>
 <20190613165130.GB5850@linux.intel.com>
 <CALCETrU8ZNL==n+fC2aH7437cstq68Xu8LJnQFnOFGCWc1L3OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU8ZNL==n+fC2aH7437cstq68Xu8LJnQFnOFGCWc1L3OQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 13, 2019 at 12:05:37PM -0700, Andy Lutomirski wrote:
> On Thu, Jun 13, 2019 at 9:51 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> > If we ditch the workqueue then we probably don't even need to gift the
> > page, e.g. I think we allocate the EPC page prior to taking mmap_sem, and
> > then simply do gup+kmap around EADD.  We'd just need to be careful about
> > not allocating EPC pages for ioctls that are guaranteed to fail.
> >
> >
> 
> Why gup + kmap?  Can't you just do STAC; EADD; CLAC?  (Using the
> appropriate C helpers, of course.)

That should work as well, we already have exception fixup on ENCLS.  I
obviously haven't given much thought to what all we can do once the
workqueue goes bye bye :-)
