Return-Path: <SRS0=s70M=YA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 790B0C47404
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Oct 2019 08:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55E3D20679
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Oct 2019 08:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbfJGIKe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 7 Oct 2019 04:10:34 -0400
Received: from mga06.intel.com ([134.134.136.31]:10826 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726889AbfJGIKd (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 7 Oct 2019 04:10:33 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 01:10:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,265,1566889200"; 
   d="scan'208";a="205005117"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.161])
  by orsmga002.jf.intel.com with ESMTP; 07 Oct 2019 01:10:26 -0700
Date:   Mon, 7 Oct 2019 11:10:24 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com,
        Andy Lutomirski <luto@amacapital.net>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v22 16/24] x86/vdso: Add support for exception fixup in
 vDSO functions
Message-ID: <20191007081024.GA5962@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-17-jarkko.sakkinen@linux.intel.com>
 <20191002231804.GA14315@linux.intel.com>
 <20191004001459.GD14325@linux.intel.com>
 <20191004185221.GI6945@linux.intel.com>
 <20191005155412.GA9159@linux.intel.com>
 <20191007075712.GA5466@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007075712.GA5466@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 07, 2019 at 10:57:12AM +0300, Jarkko Sakkinen wrote:
> On Sat, Oct 05, 2019 at 08:54:13AM -0700, Sean Christopherson wrote:
> > On Fri, Oct 04, 2019 at 09:52:21PM +0300, Jarkko Sakkinen wrote:
> > > On Thu, Oct 03, 2019 at 05:15:00PM -0700, Sean Christopherson wrote:
> > > > I'll tackle this tomorrow.  I've been working on the feature control MSR
> > > > series and will get that sent out tomorrow as well.  I should also be able
> > > > to get you the multi-page EADD patch.
> > > 
> > > Great I'll compose the patch set during the weekend and take Monday off
> > > so you have the full work day to get everything (probably send the patch
> > > set on Sunday).
> > 
> > Didn't get to the actual SGX stuff yesterday as the feature control series
> > took longer than expected to finish.  Working on the other items this
> > morning.
> 
> I anyway decided to wait for your patches.
> 
> I said in earlier email that two ioctl's would be great but I think the
> following would be the API that I would actually appreciate the most:
> 
> struct sgx_enclave_add_page_desc {
> 	__u64	addr;
> 	__u64	src;
> 	__u64	secinfo;
> 	__u16	mrmask;
> 	__u8	reserved[6];
> };
> 
> struct sgx_enclave_add_page {
> 	__u64	nr_pages;
> 	__u64	pages;
> };

Actually, maybe like this:

struct sgx_enclave_add_page_desc {
	__u64	addr;
	__u64	offset;
	__u64	secinfo;
	__u16	mrmask;
	__u8	reserved[6];
};

struct sgx_enclave_add_page {
	__u64	src;
	__u64	nr_pages;
	__u64	pages;
};

I.e. probably makes sense to fix the same source for all pages.

Also wondering if we should have special case for adding zero pages?
I.e. when you set @src to NULL ioctl would assume that zero pages
would be added?

E.g. I could use this in the selftest to create variable size data
segment.

/Jarkko
