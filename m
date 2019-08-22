Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0AD5C3A5A1
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 14:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE6B6233A1
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 14:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731445AbfHVOuu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 10:50:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:62260 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728782AbfHVOuu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 10:50:50 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 07:50:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,417,1559545200"; 
   d="scan'208";a="262882213"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 22 Aug 2019 07:50:49 -0700
Date:   Thu, 22 Aug 2019 07:50:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH for_v22 v2 8/8] x86/sgx: Pass userspace source address
 directly to EADD
Message-ID: <20190822145049.GD25467@linux.intel.com>
References: <20190813011252.4121-1-sean.j.christopherson@intel.com>
 <20190813011252.4121-9-sean.j.christopherson@intel.com>
 <74a9dbbed67ef131bf2179821ce74696120b35e1.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74a9dbbed67ef131bf2179821ce74696120b35e1.camel@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 22, 2019 at 05:37:18PM +0300, Jarkko Sakkinen wrote:
> On Mon, 2019-08-12 at 18:12 -0700, Sean Christopherson wrote:
> > Invoke EADD with the userspace source address instead of first copying
> > the data to a kernel page to avoid the overhead of alloc_page() and
> > copy_from_user().
> > 
> > Suggested-by: Andy Lutomirski <luto@kernel.org>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> NAK because takes away TCS validation and the commit message
> does not give any reasoning for doing that.

Doh, I have a thorough explanation, but apparently it never made it from
my head to the changelog.  I'll send v2 as a standalone patch.
