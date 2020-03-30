Return-Path: <SRS0=pDj2=5P=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C23C2D0F0
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 21:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9B2520714
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 21:11:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbgC3VLc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 30 Mar 2020 17:11:32 -0400
Received: from mga18.intel.com ([134.134.136.126]:44282 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728376AbgC3VLc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 30 Mar 2020 17:11:32 -0400
IronPort-SDR: 0ZKqNn7//P084IXvcEOZkfBPG2vThxmqa30UK5PNGXWnCGbBKd4hN6lSJl8fhdCK7mUaxeqXIW
 /6ap3g5xj1aA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 14:11:22 -0700
IronPort-SDR: NHk4q18l4CW+XDVRh+24jTS8bsvhkggQ8terhX1ZsZ1C2tvqwO4+GFMLol5wi7BDCBEkOQOizQ
 cDv+VtfzcERw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,325,1580803200"; 
   d="scan'208";a="294729824"
Received: from plachner-mobl.ger.corp.intel.com (HELO localhost) ([10.252.35.129])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Mar 2020 14:11:19 -0700
Date:   Tue, 31 Mar 2020 00:11:18 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v29 v2 3/5] selftests/sgx: Pass EENTER to vDSO
 wrapper instead of hardcoding
Message-ID: <20200330211118.GL1384380@linux.intel.com>
References: <20200330180811.31381-1-sean.j.christopherson@intel.com>
 <20200330180811.31381-4-sean.j.christopherson@intel.com>
 <20200330210707.GJ1384380@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330210707.GJ1384380@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 31, 2020 at 12:07:16AM +0300, Jarkko Sakkinen wrote:
> On Mon, Mar 30, 2020 at 11:08:09AM -0700, Sean Christopherson wrote:
> > Pass EENTER to the vDSO wrapper via %ecx instead of hardcoding it to
> > make the wrapper compatible with the new vDSO calling convention.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> I think it'd be good if you merge 1/5-3/5 and 4/5-55 to have two patches.
> 
> Easier to review given the strong bounds, easier for you to update
> and easier for me to merge later on.

I mean {1, 2, 3} and {4, 5}

/Jarkko
