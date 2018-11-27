Return-Path: <SRS0=TXuC=OG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F12FC43441
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Nov 2018 16:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02979208E4
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Nov 2018 16:46:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02979208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731125AbeK1DpI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 27 Nov 2018 22:45:08 -0500
Received: from mga06.intel.com ([134.134.136.31]:48914 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbeK1DpH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 27 Nov 2018 22:45:07 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2018 08:46:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,287,1539673200"; 
   d="scan'208";a="112258264"
Received: from jsakkine-mobl1.jf.intel.com (HELO localhost) ([10.24.8.96])
  by fmsmga002.fm.intel.com with ESMTP; 27 Nov 2018 08:46:38 -0800
Date:   Tue, 27 Nov 2018 08:46:38 -0800
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
Message-ID: <20181127164638.GA5646@linux.intel.com>
References: <CALCETrX+A4XaEMq3fJqmHUeeDHr_BdWh-Wk3ikXfY=L77BbaGA@mail.gmail.com>
 <20181120120442.GA22172@linux.intel.com>
 <20181122111253.GA31150@wind.enjellic.com>
 <CALCETrWJr-C6yK8NBCp=NbapwHOaBFphiDU9VKEtQ0NMRrdC2g@mail.gmail.com>
 <20181124172114.GB32210@linux.intel.com>
 <20181125145329.GA5777@linux.intel.com>
 <0669C300-02CB-4EA6-BF88-5C4B4DDAD4C7@amacapital.net>
 <20181126215145.GC868@linux.intel.com>
 <20181126230436.GA6737@linux.intel.com>
 <20181127085533.GA12247@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181127085533.GA12247@wind.enjellic.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Nov 27, 2018 at 02:55:33AM -0600, Dr. Greg wrote:
> 3.) Enclaves with the SGX_FLAGS_LICENSE_KEY attribute set - i.e., 'Launch
> Enclaves'.

Kernel does not have to manage this. If the MSRs are read-only, they
should match your LE. If the MSRs writable, you don't need an LE.

This whole scheme sounds like adding own SELinux for SGX and it is
only words. No code available.

/Jarkko
