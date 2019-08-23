Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54FF1C3A5A2
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 19:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3128821897
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 19:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403957AbfHWTPv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Aug 2019 15:15:51 -0400
Received: from mga03.intel.com ([134.134.136.65]:12925 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388918AbfHWTPv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Aug 2019 15:15:51 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 12:15:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,422,1559545200"; 
   d="scan'208";a="180767059"
Received: from budiraha-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.54.8])
  by fmsmga007.fm.intel.com with ESMTP; 23 Aug 2019 12:15:48 -0700
Date:   Fri, 23 Aug 2019 22:15:46 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org, sean.j.christopherson@intel.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com, luto@kernel.org
Subject: Re: sgx_reclaimer_write() refinement
Message-ID: <20190823191546.4wmkv3sh75x3czbb@linux.intel.com>
References: <20190823190809.n3np4v7hvlj5isku@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823190809.n3np4v7hvlj5isku@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Aug 23, 2019 at 10:08:09PM +0300, Jarkko Sakkinen wrote:
> It would greatly reduce the complexity of the flow. Would be much easier
> to do fallback code paths. We have three trial EWB approach, which
> should prevent already unnecesaary ETRACK's and IPI's.

I recall that I used a cluster ages ago to do minimize ETRACK's and
IPI's. I implemented three trial EWB during the Spring 2018 when the
reclaimer code was heavily refined but failed to notice that it rendered
cluster's meaningless...

/Jarkko
