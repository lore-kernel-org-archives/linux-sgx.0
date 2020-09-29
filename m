Return-Path: <SRS0=LTc5=DG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F17FC4346E
	for <linux-sgx@archiver.kernel.org>; Tue, 29 Sep 2020 04:05:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11EBA208FE
	for <linux-sgx@archiver.kernel.org>; Tue, 29 Sep 2020 04:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725535AbgI2EFe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 29 Sep 2020 00:05:34 -0400
Received: from mga06.intel.com ([134.134.136.31]:31521 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgI2EFe (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 29 Sep 2020 00:05:34 -0400
IronPort-SDR: Y7nE4NDAhwoLaYQNrYml7e8HvZhIT+CBOUz/dslKQLinS4yoZeJO0kuq73ANCOGoq1nDala0L9
 q9pvv2ya9qmw==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="223699135"
X-IronPort-AV: E=Sophos;i="5.77,316,1596524400"; 
   d="scan'208";a="223699135"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 21:05:33 -0700
IronPort-SDR: iZSKmayZEHDcJLbGgcE5jfe9paSA/H1Upti0oBr800nlSWuQn/BTiylluBMqvQvdcz5VB7SHbZ
 IA++IStvfudg==
X-IronPort-AV: E=Sophos;i="5.77,317,1596524400"; 
   d="scan'208";a="488909080"
Received: from jlasecki-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.49.78])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 21:05:25 -0700
Date:   Tue, 29 Sep 2020 07:05:21 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
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
Message-ID: <20200929040521.GC301037@linux.intel.com>
References: <20200928201959.GA3856@linux.intel.com>
 <E16AF0FA-3017-4323-BDD9-56DCA33CED74@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E16AF0FA-3017-4323-BDD9-56DCA33CED74@amacapital.net>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 28, 2020 at 06:37:54PM -0700, Andy Lutomirski wrote:
> I don’t personally care that much about EMODPE but, you could probably
> get the point across with something like:
> 
> SGX’s EPCM permission bits do not obviate the need to enforce these
> rules in the PTEs because enclaves can freely modify the EPCM
> permissions using EMODPE.
> 
> IOW, EMODPE is not really special here; rather, EMODPE’s existence
> demonstrates that EADD / EEXTEND are not special.

So I did "disagree and commit" with this one. I'm not actually
diagreeing on anything what Dave wrote, on the contrary it is an
understandable high level description. I just thought that it would not
hurt to remark that the ISA contains such peculiarities as EMODPE.

I did only very rudimentary clean up for the text (e.g. fix the ioctl
name, add shortt summary and not much else).

Does not make sense to waste more time to this. I'll move on to
implement the missing boot time patching for the vDSO so that we
get the next version out.

"
mm: Add 'mprotect' hook to struct vm_operations_struct

Background
==========

1. SGX enclave pages are populated with data by copying data to them
   from normal memory via ioctl(fd, SGX_IOC_ENCLAVE_ADD_PAGES).
2. We want to be able to restrict those normal memory data sources.  For
   instance, before copying data to an executable enclave page, we might
   ensure that the source is executable.
3. Enclave page permissions are dynamic just like normal permissions and
   can be adjusted at runtime with mprotect() (along with a
   corresponding special instruction inside the enclave).
4. The original data source may have have long since vanished at the
   time when enclave page permission are established (mmap() or
   mprotect()).

Solution
========

The solution is to force enclaves creators to declare their intent up front
to ioctl(fd, SGX_IOC_ENCLAVE_ADD_PAGES).  This intent can me immediately
compared to the source data mapping (and rejected if necessary).  It is
also stashed off and then later compared with enclave PTEs to ensure that
any future mmap()/mprotect() operations performed by the enclave creator or
the enclave itself are consistent with the earlier declared permissions.

Essentially, this means that whenever the kernel is asked to change an
enclave PTE, it needs to ensure the change is consistent with that stashed
intent.  There is an existing vm_ops->mmap() hook which allows SGX to do
that for mmap().  However, there is no ->mprotect() hook.  Add a
vm_ops->mprotect() hook so that mprotect() operations which are
inconsistent with any page's stashed intent can be rejected by the driver.

Implications
============

However, there is currently no implementation of the intent checks at the
time of ioctl(fd, SGX_IOC_ENCLAVE_ADD_PAGES).  That means that the intent
argument (SGX_PROT_*) is currently unused.
"

/Jarkko
