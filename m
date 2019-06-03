Return-Path: <SRS0=nxNq=UC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D8EC04AB5
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 23:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CF1A25D50
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 23:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbfFCXpy convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 3 Jun 2019 19:45:54 -0400
Received: from mga17.intel.com ([192.55.52.151]:3668 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbfFCXpx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 3 Jun 2019 19:45:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jun 2019 16:45:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,548,1549958400"; 
   d="scan'208";a="181334111"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by fmsmga002.fm.intel.com with ESMTP; 03 Jun 2019 16:45:51 -0700
Received: from orsmsx123.amr.corp.intel.com (10.22.240.116) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 3 Jun 2019 16:45:46 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.165]) by
 ORSMSX123.amr.corp.intel.com ([169.254.1.141]) with mapi id 14.03.0415.000;
 Mon, 3 Jun 2019 16:45:46 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Subject: RE: [RFC PATCH 3/9] x86/sgx: Allow userspace to add multiple pages
 in single ioctl()
Thread-Topic: [RFC PATCH 3/9] x86/sgx: Allow userspace to add multiple pages
 in single ioctl()
Thread-Index: AQHVGAki7TYpY4ZsUk+m4jTej+khLaaJYAJQgAF1XwCAAAjgAP//veIw
Date:   Mon, 3 Jun 2019 23:45:45 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654ED478@ORSMSX116.amr.corp.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-4-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F654ECBBD@ORSMSX116.amr.corp.intel.com>
 <20190603200804.GG13384@linux.intel.com>
 <20190603203950.GJ13384@linux.intel.com>
In-Reply-To: <20190603203950.GJ13384@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZTEzYzAxMTAtYzhkNC00MDZhLWFmMjEtMzY1OTQ4YzBhMWRiIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoibkE2Rm5qdWZyak14eVpBbHk3QUlrYlQreE4wWFVSNE9GclBmWU5zcjhiYlQ5dEVxelJyam9VdDZYalVMMjlpRSJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> From: Christopherson, Sean J
> Sent: Monday, June 03, 2019 1:40 PM
> 
> On Mon, Jun 03, 2019 at 01:08:04PM -0700, Sean Christopherson wrote:
> > On Sun, Jun 02, 2019 at 11:26:09PM -0700, Xing, Cedric wrote:
> > > > From: Christopherson, Sean J
> > > > Sent: Friday, May 31, 2019 4:32 PM
> > > >
> > > > +/**
> > > > + * sgx_ioc_enclave_add_pages - handler for
> > > > +%SGX_IOC_ENCLAVE_ADD_PAGES
> > > > + *
> > > > + * @filep:	open file to /dev/sgx
> > > > + * @cmd:	the command value
> > > > + * @arg:	pointer to an &sgx_enclave_add_page instance
> > > > + *
> > > > + * Add a range of pages to an uninitialized enclave (EADD), and
> > > > +optionally
> > > > + * extend the enclave's measurement with the contents of the page
> (EEXTEND).
> > > > + * The range of pages must be virtually contiguous.  The SECINFO
> > > > +and
> > > > + * measurement maskare applied to all pages, i.e. pages with
> > > > +different
> > > > + * properties must be added in separate calls.
> > > > + *
> > > > + * EADD and EEXTEND are done asynchronously via worker threads.
> > > > +A successful
> > > > + * sgx_ioc_enclave_add_page() only indicates the pages have been
> > > > +added to the
> > > > + * work queue, it does not guarantee adding the pages to the
> > > > +enclave will
> > > > + * succeed.
> > > > + *
> > > > + * Return:
> > > > + *   0 on success,
> > > > + *   -errno otherwise
> > > > + */
> > > > +static long sgx_ioc_enclave_add_pages(struct file *filep,
> unsigned int cmd,
> > > > +				      unsigned long arg)
> > > > +{
> > > > +	struct sgx_enclave_add_pages *addp = (void *)arg;
> > > > +	struct sgx_encl *encl = filep->private_data;
> > > > +	struct sgx_secinfo secinfo;
> > > > +	unsigned int i;
> > > > +	int ret;
> > > > +
> > > > +	if (copy_from_user(&secinfo, (void __user *)addp->secinfo,
> > > > +			   sizeof(secinfo)))
> > > > +		return -EFAULT;
> > > > +
> > > > +	for (i = 0, ret = 0; i < addp->nr_pages && !ret; i++) {
> > > > +		if (signal_pending(current))
> > > > +			return -ERESTARTSYS;
> > >
> > > If interrupted, how would user mode code know how many pages have
> been EADD'ed?
> >
> > Hmm, updating nr_pages would be fairly simple and shouldn't confuse
> > userspace, e.g. as opposed to overloading the return value.
> 
> Or maybe update @addr and @src as well?  That would allow userspace to
> re-invoke the ioctl() without having to modify the struct.

How about returning the number of pages (or bytes) EADD'ed, similar to write() syscall? 
