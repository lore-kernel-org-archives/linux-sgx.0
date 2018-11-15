Return-Path: <SRS0=gtji=N2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51662C43441
	for <linux-sgx@archiver.kernel.org>; Thu, 15 Nov 2018 20:16:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22DC220858
	for <linux-sgx@archiver.kernel.org>; Thu, 15 Nov 2018 20:16:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22DC220858
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388928AbeKPGZx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 16 Nov 2018 01:25:53 -0500
Received: from mga06.intel.com ([134.134.136.31]:39486 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbeKPGZx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 16 Nov 2018 01:25:53 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Nov 2018 12:16:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,237,1539673200"; 
   d="scan'208";a="104924663"
Received: from ncanderx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.140])
  by fmsmga002.fm.intel.com with ESMTP; 15 Nov 2018 12:16:26 -0800
Date:   Thu, 15 Nov 2018 22:16:25 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v16 18/22] platform/x86: Intel SGX driver
Message-ID: <20181115201625.GA25953@linux.intel.com>
References: <20181106134758.10572-1-jarkko.sakkinen@linux.intel.com>
 <20181106134758.10572-19-jarkko.sakkinen@linux.intel.com>
 <1541522400.7839.48.camel@intel.com>
 <20181107163757.GB11509@linux.intel.com>
 <20181107180057.GB24807@linux.intel.com>
 <20181108144603.GA14072@linux.intel.com>
 <20181115200002.GA24006@linux.intel.com>
 <20181115200406.GA24299@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115200406.GA24299@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Nov 15, 2018 at 10:04:06PM +0200, Jarkko Sakkinen wrote:
> On Thu, Nov 15, 2018 at 10:00:02PM +0200, Jarkko Sakkinen wrote:
> > On Thu, Nov 08, 2018 at 04:46:03PM +0200, Jarkko Sakkinen wrote:
> > > On Wed, Nov 07, 2018 at 10:00:57AM -0800, Sean Christopherson wrote:
> > > > What do we gain by a single buffer vs. separate buffers?  The ioctl()
> > > > would be slightly smaller but it seems like the actual code would be
> > > > more complex.
> > > 
> > > I'm fine with either. It was just a suggestion.
> > > 
> > > > The enclave build process also utilizes the backing as temp storage
> > > > to avoid having to alloc kernel memory when queueing pages to be added
> > > > by the worker thread (which reminds me that I wanted to document why a
> > > > worker thread is used).  Keeping this behavior would effectively make
> > > > providing backing mandatory.
> > > 
> > > Would it be a problem just allocate those pages with alloc_page() and
> > > free them in the worker thread?
> > > 
> > > > Are there any potential complications with ENCLS consuming userspace
> > > > pointers?  We'd have to wrap them with user_access_{begin,end}() and
> > > > probably tweak the fixup, but I assume having the fixup handler means
> > > > we're generally ok?
> > > 
> > > Last time I did it I used get_user_pages() for pinning. I'm not sure
> > > why I should do anything but just re-use that.
> > 
> > What about VA page swapping? Not saying that it'd have to be done right
> > now but we need to answer whether it is enclave local or a global asset.
> > If it is local it would also require an argument.
> > 
> > I will most likely won't fix this for v17 because this detail needs
> > careful consideration.
> 
> I wonder if you can map shmem file to process address space so that you
> get it accounted for the process? That would be optimal for us. This way
> this won't become an API issue.
> 
> Yeah, as I started to implement this I realized these issues with the
> API side that will arise. Even doing vm_mmap() in the kernel code would
> be better than taking addresses through the ioctl. That is another
> option.

This is how strongly think. I can go with VMAs for swapping *but* if
that is the route I would recommend using vm_mmap() instead of taking
pointer from user space. This way the way swapping is done can be always
changed. It will be a huge lock-in to do it otherwise.

/Jarkko
