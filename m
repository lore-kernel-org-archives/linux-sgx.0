Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C53C3A5A2
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 13:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1900722CE3
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 13:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732014AbfHWNlk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Aug 2019 09:41:40 -0400
Received: from mga14.intel.com ([192.55.52.115]:14213 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731976AbfHWNlk (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Aug 2019 09:41:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 06:41:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,421,1559545200"; 
   d="scan'208";a="203772931"
Received: from unknown (HELO jsakkine-mobl1) ([10.252.39.229])
  by fmsmga004.fm.intel.com with ESMTP; 23 Aug 2019 06:41:39 -0700
Message-ID: <40ddfa6f1779332a37fb57590a1f8530ea62a909.camel@linux.intel.com>
Subject: Re: [PATCH 4/5] x86/sgx: Validate TCS permssions in
 sgx_validate_secinfo()
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Date:   Fri, 23 Aug 2019 16:41:38 +0300
In-Reply-To: <20190823020522.GK25467@linux.intel.com>
References: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
         <20190819152544.7296-5-jarkko.sakkinen@linux.intel.com>
         <20190822035510.GV29345@linux.intel.com>
         <d0e8313b7817a43151b11602ad55b1136f614850.camel@linux.intel.com>
         <20190822163458.GG25467@linux.intel.com>
         <37fcfdb9f54c01573a83de439e6cbd51ff677649.camel@linux.intel.com>
         <ef15d08e54d62cea3f659e17f0a1b4a881aeb96f.camel@linux.intel.com>
         <20190823020522.GK25467@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2019-08-22 at 19:05 -0700, Sean Christopherson wrote:
> > This can we verified from the SDM easily (SCRATCH_SECINFO gets zeros
> > is extended after that).
> > 
> > And also from my signing tool :-)
> > 
> > for (offset = 0; offset < sb.st_size; offset += 0x1000) {
> > 	if (!offset)
> > 		flags = SGX_SECINFO_TCS;
> > 	else
> > 		flags = SGX_SECINFO_REG | SGX_SECINFO_R |
> > 			SGX_SECINFO_W | SGX_SECINFO_X;
> > 
> > OK, so this looks like that my patch does exactly the right thing,
> > right?
> 
> That's my understanding as well.  Definitely worthy of a comment
> explaining all of the above.

Now that I looked at my own code I even remember going through this
same thought process three years ago when I wrote that :-) Oh well.

So should I apply my zero check patch?

/Jarkko

