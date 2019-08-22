Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ACB4C3A5A1
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 16:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEC6F23401
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 16:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730411AbfHVQ7h (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 12:59:37 -0400
Received: from mga06.intel.com ([134.134.136.31]:59259 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726844AbfHVQ7h (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 12:59:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 09:59:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,417,1559545200"; 
   d="scan'208";a="208240577"
Received: from greathea-mobl2.ger.corp.intel.com ([10.252.39.37])
  by fmsmga002.fm.intel.com with ESMTP; 22 Aug 2019 09:59:34 -0700
Message-ID: <6a5fb735e795c25ceb075d4a6f4db20653b731af.camel@linux.intel.com>
Subject: Re: [PATCH 4/5] x86/sgx: Validate TCS permssions in
 sgx_validate_secinfo()
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Ayoun, Serge" <serge.ayoun@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Cc:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Date:   Thu, 22 Aug 2019 19:59:34 +0300
In-Reply-To: <fa7ef5b767298ac19857d8342a8eca65e31eb843.camel@linux.intel.com>
References: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
         <20190819152544.7296-5-jarkko.sakkinen@linux.intel.com>
         <20190821184544.ii37h7hhxjiocbb4@linux.intel.com>
         <88B7642769729B409B4A93D7C5E0C5E7C661E7A7@hasmsx108.ger.corp.intel.com>
         <fa7ef5b767298ac19857d8342a8eca65e31eb843.camel@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2019-08-22 at 19:46 +0300, Jarkko Sakkinen wrote:
> On Thu, 2019-08-22 at 11:33 +0000, Ayoun, Serge wrote:
> > Also replying to Sean.
> > Sean is right that never mind the value in secsinfo->flags, HW will reset RWX
> > For TCS pages.
> > So basically you may not enforce and and could not check those but... The signature depends
> > On those flags, so if you put a non-zero flag value, eadd will pass but if you
> > compute the signature according to this non zero value then you will have
> > a delta between ur signature and HW's signature: einit will fail.
> > So this is tricky and more a usability issue.
> > I vote for checking the flag is zeroed.
> 
> As I responded to Sean that as long as the ioctl does not adjust
> prot bits I'm cool with any sane solution. What do you think of
> requiring at minimum RW?
> 
> Doing that kind of adjusting is just doing fixup's for corrupted
> data from the user space.

Kind of missed your comment about EINIT in rush! A valid point
and good catch.

I still think my 2nd proposal would be more appropriate than this
patch. Signatures will work and we don't need special cases anywhere.

/Jarkko

