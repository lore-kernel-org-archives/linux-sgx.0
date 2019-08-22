Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA525C3A5A1
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 14:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AAAE21726
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 14:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbfHVO1v (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 10:27:51 -0400
Received: from mga18.intel.com ([134.134.136.126]:47901 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727953AbfHVO1v (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 10:27:51 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 07:27:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,417,1559545200"; 
   d="scan'208";a="169798733"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 22 Aug 2019 07:27:50 -0700
Date:   Thu, 22 Aug 2019 07:27:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Ayoun, Serge" <serge.ayoun@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Subject: Re: [PATCH 4/5] x86/sgx: Validate TCS permssions in
 sgx_validate_secinfo()
Message-ID: <20190822142750.GC25467@linux.intel.com>
References: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
 <20190819152544.7296-5-jarkko.sakkinen@linux.intel.com>
 <20190821184544.ii37h7hhxjiocbb4@linux.intel.com>
 <88B7642769729B409B4A93D7C5E0C5E7C661E7A7@hasmsx108.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88B7642769729B409B4A93D7C5E0C5E7C661E7A7@hasmsx108.ger.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 22, 2019 at 04:33:35AM -0700, Ayoun, Serge wrote:
> Sean is right that never mind the value in secsinfo->flags, HW will reset RWX
> For TCS pages.  So basically you may not enforce and and could not check
> those but... The signature depends On those flags, so if you put a non-zero
> flag value, eadd will pass but if you compute the signature according to this
> non zero value then you will have a delta between ur signature and HW's
> signature: einit will fail.  So this is tricky and more a usability issue.  I
> vote for checking the flag is zeroed.

Ugh, didn't think about that behavior.  That's obnoxious.  Adding the
check makes sense in that case.
