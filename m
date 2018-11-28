Return-Path: <SRS0=SAws=OH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44EC4C43441
	for <linux-sgx@archiver.kernel.org>; Wed, 28 Nov 2018 19:22:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13D7720864
	for <linux-sgx@archiver.kernel.org>; Wed, 28 Nov 2018 19:22:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13D7720864
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbeK2GZM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 29 Nov 2018 01:25:12 -0500
Received: from mga07.intel.com ([134.134.136.100]:8689 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbeK2GZM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 29 Nov 2018 01:25:12 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Nov 2018 11:22:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,291,1539673200"; 
   d="scan'208";a="288293706"
Received: from jsakkine-mobl1.jf.intel.com (HELO localhost) ([10.24.8.96])
  by fmsmga006.fm.intel.com with ESMTP; 28 Nov 2018 11:22:29 -0800
Date:   Wed, 28 Nov 2018 11:22:28 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com,
        haitao.huang@linux.intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181128192228.GC9023@linux.intel.com>
References: <CALCETrWJr-C6yK8NBCp=NbapwHOaBFphiDU9VKEtQ0NMRrdC2g@mail.gmail.com>
 <20181124172114.GB32210@linux.intel.com>
 <20181125145329.GA5777@linux.intel.com>
 <0669C300-02CB-4EA6-BF88-5C4B4DDAD4C7@amacapital.net>
 <20181126215145.GC868@linux.intel.com>
 <20181126230436.GA6737@linux.intel.com>
 <20181127085533.GA12247@wind.enjellic.com>
 <20181127164129.GB4170@linux.intel.com>
 <C11C9312-65BC-460A-8F9F-608E101AE5C1@amacapital.net>
 <20181128104941.GA23077@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128104941.GA23077@wind.enjellic.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Nov 28, 2018 at 04:49:41AM -0600, Dr. Greg wrote:
> We've been carrying a patch, that drops in on top of the proposed
> kernel driver, that implements the needed policy management framework
> for DAC fragile (FLC) platforms.  After a meeting yesterday with the
> client that is funding the work, a decision was made to release the
> enhancements when the SGX driver goes mainline.  That will at least
> give developers the option of creating solutions on Linux that
> implement the security guarantees that SGX was designed to deliver.

We do not need yet another policy management framework to the *kernel*.

The token based approach that Andy is proposing is proven and well
established method to create a mechanism. You can then create a daemon
to user space that decides who it wants to send tokes.

/Jarkko
