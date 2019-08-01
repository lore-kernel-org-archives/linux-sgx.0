Return-Path: <SRS0=jAuJ=V5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF186C433FF
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Aug 2019 16:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFA3F20657
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Aug 2019 16:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732877AbfHAQWW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Aug 2019 12:22:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:55567 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732876AbfHAQWW (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 1 Aug 2019 12:22:22 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Aug 2019 09:22:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,334,1559545200"; 
   d="scan'208";a="348135540"
Received: from ohoehne-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.51.57])
  by orsmga005.jf.intel.com with ESMTP; 01 Aug 2019 09:22:20 -0700
Date:   Thu, 1 Aug 2019 19:22:19 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Return 0 when !CONFIG_INTEL_SGX_DRIVER
Message-ID: <20190801162219.fqmkxlp4mgm4gi3f@linux.intel.com>
References: <20190714143212.971-1-jarkko.sakkinen@linux.intel.com>
 <20190715135902.GA442@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715135902.GA442@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jul 15, 2019 at 06:59:03AM -0700, Sean Christopherson wrote:
> On Sun, Jul 14, 2019 at 05:32:12PM +0300, Jarkko Sakkinen wrote:
> > When the config option is not enabled the initialization is always
> > succesful.
> 
> Why would the be initialization be considered successful?  It's dead code
> and memory consumption if the driver can't load.  When KVM support gets
> added, the initialization can be considered successful if the driver *or*
> virtual EPC are enabled and load cleanly.

When a config option disabled means it that the functionality does not
exist at all, which means that there is nothing to fail. That is why it
would be actually better to flag the whole call than the way it is done
in this patch.

/Jarkko
