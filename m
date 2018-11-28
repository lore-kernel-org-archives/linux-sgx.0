Return-Path: <SRS0=SAws=OH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C594C43441
	for <linux-sgx@archiver.kernel.org>; Wed, 28 Nov 2018 05:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46BA020832
	for <linux-sgx@archiver.kernel.org>; Wed, 28 Nov 2018 05:08:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46BA020832
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbeK1QIp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 28 Nov 2018 11:08:45 -0500
Received: from mga06.intel.com ([134.134.136.31]:57779 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbeK1QIp (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 28 Nov 2018 11:08:45 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2018 21:08:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,289,1539673200"; 
   d="scan'208";a="286893573"
Received: from djustese-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.168])
  by fmsmga005.fm.intel.com with ESMTP; 27 Nov 2018 21:08:15 -0800
Date:   Tue, 27 Nov 2018 21:08:14 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
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
Message-ID: <20181128050814.GA8842@linux.intel.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
 <CALCETrXctxfED1Dr-MuZxFnh5gzTyRL06hRJ_fQnNA8p2S4xEQ@mail.gmail.com>
 <20181119161917.GF13298@linux.intel.com>
 <CALCETrX+A4XaEMq3fJqmHUeeDHr_BdWh-Wk3ikXfY=L77BbaGA@mail.gmail.com>
 <20181120120442.GA22172@linux.intel.com>
 <20181122111253.GA31150@wind.enjellic.com>
 <CALCETrV4wOpk7wf9+ywd50PekGjfT7LNtwqHhcV08=oxPmKtKQ@mail.gmail.com>
 <20181123103923.GA13851@wind.enjellic.com>
 <20181124164534.GC30310@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181124164534.GC30310@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Nov 24, 2018 at 08:45:34AM -0800, Jarkko Sakkinen wrote:
> On Fri, Nov 23, 2018 at 04:39:23AM -0600, Dr. Greg wrote:
> > Jarkko, when this driver lands it will set the SGX ABI in stone for
> > Linux.  It would be very, very helpful to the development community if
> > there was some official guidance from Intel on whether or not FLC will
> > be a universal feature on all hardware and the date that is going to
> > happen or has happened.
> 
> I seriously don't know but I can take this message to the mothership...

LC enabling is essentially a platform vendors choice, not Intels choice,
like many other CPU features that Linux is dependent on. Of course, if
Linux ends supporting only LC that will without doubt have a big impact
on vendors so in that way it is indirectly also communitys choice.

/Jarkko
