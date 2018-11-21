Return-Path: <SRS0=smjw=OA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42522C43441
	for <linux-sgx@archiver.kernel.org>; Wed, 21 Nov 2018 15:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16F502146F
	for <linux-sgx@archiver.kernel.org>; Wed, 21 Nov 2018 15:24:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16F502146F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731277AbeKVB7U (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 21 Nov 2018 20:59:20 -0500
Received: from mga04.intel.com ([192.55.52.120]:54212 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728289AbeKVB7U (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 21 Nov 2018 20:59:20 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Nov 2018 07:24:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,261,1539673200"; 
   d="scan'208";a="88162308"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.177])
  by fmsmga008.fm.intel.com with ESMTP; 21 Nov 2018 07:24:24 -0800
Date:   Wed, 21 Nov 2018 17:24:24 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kai.svahn@intel.com" <kai.svahn@intel.com>,
        "mark.shanahan@intel.com" <mark.shanahan@intel.com>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181121152424.GC16564@linux.intel.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
 <20181119150655.GA11843@linux.intel.com>
 <e8e640be-6f9f-0835-0578-48f140ac68f9@fortanix.com>
 <20181119171934.GA16252@linux.intel.com>
 <63b97d22-9d28-e0f8-492d-27e5cc456fce@fortanix.com>
 <20181120105817.GA14594@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181120105817.GA14594@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Nov 20, 2018 at 12:58:17PM +0200, Jarkko Sakkinen wrote:
> On Mon, Nov 19, 2018 at 05:39:04PM +0000, Jethro Beekman wrote:
> > Let's keep it as separated as possible for now until KVM lands and we get
> > the module capability back, instead of integrating everything so tightly
> > Jethro Beekman | Fortanix
> 
> We can keep the driver structure and still move it under
> arch/x86/kernel/cpu. When landing the KVM code we can then allow
> the driver part to be compiled as module. It is not the only LKM
> under arch/x86.
> 
> Would also simplify both way we develop SGX code alot, not least
> because there would be clear consumer of the pull requests.

The purpose is not to thrawt the driver structure for user space facing
part. The purpose is only make logicistics work better for
post-upstreaming maintenance.

I'll move on with this for v18 unless there is a good reason not to.

/Jarkko
