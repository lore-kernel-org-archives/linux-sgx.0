Return-Path: <SRS0=nxNq=UC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99245C28CC6
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 21:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C52A26D3F
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 21:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfFCV7j (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 3 Jun 2019 17:59:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:65178 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726572AbfFCV7j (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 3 Jun 2019 17:59:39 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jun 2019 13:37:12 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga008.jf.intel.com with ESMTP; 03 Jun 2019 13:37:12 -0700
Date:   Mon, 3 Jun 2019 13:37:12 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Cedric Xing <cedric.xing@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, nhorman@redhat.com,
        npmccallum@redhat.com, Serge Ayoun <serge.ayoun@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Haitao Huang <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kai Svahn <kai.svahn@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Kai Huang <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        William Roberts <william.c.roberts@intel.com>,
        Philip Tricca <philip.b.tricca@intel.com>
Subject: Re: [RFC PATCH 3/9] x86/sgx: Allow userspace to add multiple pages
 in single ioctl()
Message-ID: <20190603203712.GI13384@linux.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-4-sean.j.christopherson@intel.com>
 <beb8ac7a-b580-8ff2-7467-fb2870fb8cf0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <beb8ac7a-b580-8ff2-7467-fb2870fb8cf0@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 03, 2019 at 01:14:45PM -0700, Dave Hansen wrote:
> On 5/31/19 4:31 PM, Sean Christopherson wrote:
> > -struct sgx_enclave_add_page {
> > +struct sgx_enclave_add_pages {
> >  	__u64	addr;
> >  	__u64	src;
> >  	__u64	secinfo;
> > +	__u32	nr_pages;
> >  	__u16	mrmask;
> >  } __attribute__((__packed__));
> 
> IMNHO this follows a user interface anti-pattern: exposing page sizes
> where not strictly required.
> 
> Think of how this would look to an application if page size was
> variable.  With this interface, they always need to scale their
> operations by page size instead of just aligning it.

I briefly considered taking size in bytes, but I took a shortcut because
EPC pages are architecturally defined to be 4k sized and aligned.  That
being said, I don't necessarily disagree, especially if nr_pages isn't
squeezed into a u32.
 
> BTW, why is nr_pages a u32?  Do we never envision a case where you can
> add more than 4TB of memory to an enclave? ;)

Heh, fair enough.  IIRC, a while back someone posted about having problems
building a 512gb enclave in a 92mb EPC...

How about this for the intermediate patch:

	struct sgx_enclave_add_region {
		__u64	addr;
		__u64	src;
		__u64	size;
		__u64	secinfo;
		__u16	mrmask;
		__u16	reserved16;
		__u32	reserved;
	}

and with the flags field:

	struct sgx_enclave_add_region {
		__u64	addr;
		__u64	src;
		__u64	size;
		__u64	secinfo;
		__u16	mrmask;
		__u16	flags;
		__u32	reserved;
	}
