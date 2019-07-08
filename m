Return-Path: <SRS0=W/oj=VF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D8DC606BD
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 14:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99A40216B7
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 14:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731789AbfGHOeO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Jul 2019 10:34:14 -0400
Received: from mga12.intel.com ([192.55.52.136]:15546 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728725AbfGHOeO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 8 Jul 2019 10:34:14 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 07:34:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,466,1557212400"; 
   d="scan'208";a="167693008"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by orsmga003.jf.intel.com with ESMTP; 08 Jul 2019 07:34:13 -0700
Date:   Mon, 8 Jul 2019 07:34:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC PATCH v4 12/12] LSM: x86/sgx: Show line of sight to LSM
 support SGX2's EAUG
Message-ID: <20190708143413.GB20433@linux.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-13-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F655184EC@ORSMSX116.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F655184EC@ORSMSX116.amr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jun 21, 2019 at 10:18:55AM -0700, Xing, Cedric wrote:
> > From: Christopherson, Sean J
> > Sent: Wednesday, June 19, 2019 3:24 PM
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
> > index 4379a2fb1f82..b478c0f45279 100644
> > --- a/arch/x86/kernel/cpu/sgx/driver/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/driver/main.c
> > @@ -99,7 +99,8 @@ static long sgx_compat_ioctl(struct file *filep, unsigned int cmd,
> >   * page is considered to have no RWX permissions, i.e. is inaccessible.
> >   */
> >  static unsigned long sgx_allowed_rwx(struct sgx_encl *encl,
> > -				     struct vm_area_struct *vma)
> > +				     struct vm_area_struct *vma,
> > +				     bool *eaug)
> >  {
> >  	unsigned long allowed_rwx = VM_READ | VM_WRITE | VM_EXEC;
> >  	unsigned long idx, idx_start, idx_end; @@ -123,6 +124,8 @@ static unsigned long
> > sgx_allowed_rwx(struct sgx_encl *encl,
> >  			allowed_rwx = 0;
> >  		else
> >  			allowed_rwx &= page->vm_prot_bits;
> > +		if (page->vm_prot_bits & SGX_VM_EAUG)
> > +			*eaug = true;
> >  		if (!allowed_rwx)
> >  			break;
> >  	}
> > @@ -134,16 +137,17 @@ static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
> > {
> >  	struct sgx_encl *encl = file->private_data;
> >  	unsigned long allowed_rwx, prot;
> > +	bool eaug = false;
> >  	int ret;
> > 
> > -	allowed_rwx = sgx_allowed_rwx(encl, vma);
> > +	allowed_rwx = sgx_allowed_rwx(encl, vma, &eaug);
> >  	if (vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC) & ~allowed_rwx)
> >  		return -EACCES;
> 
> IIUC, "eaug range" has to be mapped PROT_NONE, then vm_ops->fault() won't be
> invoked. Am I correct? Then how to EAUG on #PF?

Pages tagged SGX_VM_EAUG also have maximal permissions and can be mapped
PROT_{READ,WRITE,EXEC} accordingly.

> 
> > 
> >  	prot = _calc_vm_trans(vma->vm_flags, VM_READ, PROT_READ) |
> >  	       _calc_vm_trans(vma->vm_flags, VM_WRITE, PROT_WRITE) |
> >  	       _calc_vm_trans(vma->vm_flags, VM_EXEC, PROT_EXEC);
> > -	ret = security_enclave_map(prot);
> > +	ret = security_enclave_map(prot, eaug);
> >  	if (ret)
> >  		return ret;
> > 
