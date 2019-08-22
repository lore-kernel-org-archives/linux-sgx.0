Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B07EC3A5A1
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 16:13:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F322F21743
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 16:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731632AbfHVQNb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 12:13:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:56620 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731608AbfHVQNb (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 12:13:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 09:13:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,417,1559545200"; 
   d="scan'208";a="354335697"
Received: from greathea-mobl2.ger.corp.intel.com ([10.252.39.37])
  by orsmga005.jf.intel.com with ESMTP; 22 Aug 2019 09:13:28 -0700
Message-ID: <79055c34e594caad23ad44601cde826cc4c20ac9.camel@linux.intel.com>
Subject: Re: [PATCH v3 7/7] selftests/x86: Recurse into subdirectories
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com
Date:   Thu, 22 Aug 2019 19:13:26 +0300
In-Reply-To: <70eaaa28acc8f773d20a4371a99a4a90745129bb.camel@linux.intel.com>
References: <20190819132830.9056-1-jarkko.sakkinen@linux.intel.com>
         <20190819132830.9056-8-jarkko.sakkinen@linux.intel.com>
         <20190822034204.GR29345@linux.intel.com>
         <10e17b91a46c1f3c8ef66baf987cd3d66ed14424.camel@linux.intel.com>
         <70eaaa28acc8f773d20a4371a99a4a90745129bb.camel@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2019-08-22 at 18:02 +0300, Jarkko Sakkinen wrote:
> On Thu, 2019-08-22 at 17:59 +0300, Jarkko Sakkinen wrote:
> > On Wed, 2019-08-21 at 20:42 -0700, Sean Christopherson wrote:
> > > On Mon, Aug 19, 2019 at 04:28:30PM +0300, Jarkko Sakkinen wrote:
> > > > Recurse into a list of subdirectories defined by SUBDIRS when running
> > > > x86 selftests. Override run_tests, install, emit_tests and clean
> > > > targets to implement this behaviour.
> > > 
> > > The code looks good (which doesn't say much, my Makefile knowledge is
> > > garbage), but the result is a bit odd.  x86/sgx doesn't implement
> > > emit_tests (or at least test_sgx doesn't show up), while the rest of the
> > > x86 tests don't support install.
> > > 
> > > AFAICT the Makefile is itself weird; it's definitely different than other
> > > selftests Makfiles.  I don't see any reason to delay this patch, but it
> > > feels like something here needs to be cleaned up.
> > 
> > Lets fix emit_tests before sending v22.
> 
> Selftest patches have been squahed. Further improvements are welcome.
> Thanks for the review!

At least my use case is satisfied with these fixes:

$ ls output/target/usr/lib/kselftests/x86 
test_sgx

I can build initramfs now with the selftest bundled. Oddly enough none of the
other x86 selftests get included.

/Jarkko

