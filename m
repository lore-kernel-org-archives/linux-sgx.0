Return-Path: <SRS0=YjYT=DA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C29C4363D
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Sep 2020 14:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89E0D21D43
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Sep 2020 14:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgIWOdQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 23 Sep 2020 10:33:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:57822 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgIWOdP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 23 Sep 2020 10:33:15 -0400
IronPort-SDR: ZkyNyoPd3h1HfwwPjicwPH4aJkXqjh22WZqPdqbO6R9es3C5IGMmbgsfoyYQ6SStyeg0M8m6d/
 3WTNs+0GO0+Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9752"; a="148552790"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="148552790"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 07:33:14 -0700
IronPort-SDR: ItLiQJZoZ4CdNDBYceiZlvD85IZXi7GL/1hQJIpXeosadYCS1uHk+MasVby8eq6GxSbZFtzxqO
 PXxbe8IMI3gw==
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="486460853"
Received: from ichiojdo-mobl.ger.corp.intel.com (HELO localhost) ([10.252.51.82])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 07:33:08 -0700
Date:   Wed, 23 Sep 2020 17:33:05 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        "Xing, Cedric" <cedric.xing@intel.com>, chenalexchen@google.com,
        Conrad Parker <conradparker@google.com>, cyhanish@google.com,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Subject: Re: [PATCH v38 10/24] mm: Add vm_ops->mprotect()
Message-ID: <20200923143305.GE5160@linux.intel.com>
References: <20200918235337.GA21189@sjchrist-ice>
 <1B23E216-0229-4BDD-8B09-807256A54AF5@amacapital.net>
 <20200922125801.GA133710@linux.intel.com>
 <25d46fdc-1c19-2de8-2ce8-1033a0027ecf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25d46fdc-1c19-2de8-2ce8-1033a0027ecf@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 22, 2020 at 08:11:14AM -0700, Dave Hansen wrote:
> Now I'm confused.  I actually don't think I have a strong understanding
> of how an enclave actually gets loaded, how mmap() and mprotect() are
> normally used and what this hook is intended to thwart.

You saw my other comments. I scraped this together based on your
feedback and my responses:

"
mm: Add 'mprotect' callback to vm_ops

Intel Sofware Guard eXtensions (SGX) allows creation of blobs called
enclaves, for which page permissions are defined when the enclave is first
loaded. Once an enclave is loaded and initialized, it can be mapped to the
process address space.

There is no standard file format for enclaves. They are dynamically built
and the ways how enclaves are deployed differ greatly. For an app you might
want to have a simple static binary, but on the other hand for a container
you might want to dynamically create the whole thing at run-time. Also, the
existing ecosystem for SGX is already large, which would make the task very
hard.

Finally, even if there was a standard format, one would still want a
dynamic way to add pages to the enclave. One big reason for this is that
enclaves have load time defined pages that represent entry points to the
enclave. Each entry point can service one hardware thread at a time and
you might want to run-time parametrize this depending on your environment.

The consequence is that enclaves are best created with an ioctl API and the
access control can be based only to the origin of the source file for the
enclave data, i.e. on VMA file pointer and page permissions. For example,
this could be done with LSM hooks that are triggered in the appropriate
ioctl's and they could make the access control decision based on this
information.

Unfortunately, there is ENCLS[EMODPE] that a running enclave can use to
upgrade its permissions. If we do not limit mmap() and mprotect(), enclave
could upgrade its permissions by using EMODPE followed by an appropriate
mprotect() call. This would be completely hidden from the kernel.

Add 'mprotect' hook to vm_ops, so that a callback can be implemeted for SGX
that will ensure that {mmap, mprotect}() permissions do not surpass any of
the original page permissions. This feature allows to maintain and refine
sane access control for enclaves.
"

/Jarkko
