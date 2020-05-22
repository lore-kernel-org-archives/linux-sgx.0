Return-Path: <SRS0=O4vE=7E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4337FC433E1
	for <linux-sgx@archiver.kernel.org>; Fri, 22 May 2020 19:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B374206D5
	for <linux-sgx@archiver.kernel.org>; Fri, 22 May 2020 19:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730849AbgEVT0Q (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 22 May 2020 15:26:16 -0400
Received: from mga03.intel.com ([134.134.136.65]:19921 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730689AbgEVT0Q (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 22 May 2020 15:26:16 -0400
IronPort-SDR: X5L2zUcyoPXFR6heNei79v1IiZYSU5ZZXTScWyzcdBq2qPe469IuwRpLYBcrMZbKX6+uigRX51
 5yZGr25e+qbw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 12:26:15 -0700
IronPort-SDR: byZjjo03dLCqvP6zTjKxKcmePMihPj+c61mrPmnwykVcBKNwMfmTQJrnKOPRqZTk0ZxpJEi6WO
 ec3hAJilTBtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,422,1583222400"; 
   d="scan'208";a="412848366"
Received: from rpurrx-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.58.10])
  by orsmga004.jf.intel.com with ESMTP; 22 May 2020 12:26:09 -0700
Date:   Fri, 22 May 2020 22:26:09 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Seth Moore <sethmo@google.com>
Subject: Re: [PATCH v30 10/20] x86/sgx: Linux Enclave Driver
Message-ID: <20200522192609.GE10319@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-11-jarkko.sakkinen@linux.intel.com>
 <20200521191236.GA23043@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521191236.GA23043@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 21, 2020 at 12:12:36PM -0700, Sean Christopherson wrote:
> On Fri, May 15, 2020 at 03:44:00AM +0300, Jarkko Sakkinen wrote:
> > +long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
> > +{
> > +	struct sgx_encl *encl = filep->private_data;
> > +	int ret, encl_flags;
> > +
> > +	encl_flags = atomic_fetch_or(SGX_ENCL_IOCTL, &encl->flags);
> > +	if (encl_flags & SGX_ENCL_IOCTL)
> > +		return -EBUSY;
> > +
> > +	if (encl_flags & SGX_ENCL_DEAD)
> > +		return -EFAULT;
> 
> Returning immediately is wrong as it leaves SGX_ENCL_IOCTL set.  This results
> in the application seeing -EBUSY on future ioctls() instead of -EFAULT.  Can be
> fixed as below.  Do you want me to send a formal patch on linux-sgx?

I just rewrote the same thing.

/Jarkko
