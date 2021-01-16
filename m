Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86A67C433E0
	for <linux-sgx@archiver.kernel.org>; Sat, 16 Jan 2021 09:51:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B5D421BE5
	for <linux-sgx@archiver.kernel.org>; Sat, 16 Jan 2021 09:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725979AbhAPJvi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 16 Jan 2021 04:51:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:39474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725928AbhAPJvh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 16 Jan 2021 04:51:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27CB4206D5;
        Sat, 16 Jan 2021 09:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610790656;
        bh=fymB0S/JtJWUAJLdLaFMjTbgs2PWZvDpYZFOfxMdloU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j1IXaaEL942XJJzPyw2ijBZdZ2qFC9F5ggnqSlrsJe6vsyBbquxOdwb8rWMRKOTuS
         vjahNUJLkdDq+Qo8tlXXlK2Mffknz9my6zJCyAOP7JwO9dNgcCeiQKdVCLP9twzwS/
         OO1LRytgaz9dgsQaG5JcpDJrUFtGg4uPtQAKgrcS9HIVMRKiW9pNep+Jx7w8T23yK8
         4YKLBI4AgAW+iOf8CxLVrZFi/JwWk6PRc2JNOh3q6HzQJm2fkmboxhrITqjRKHc9Cx
         6fhEj1hPd2H1q+k0pKhYQiyFGz/NFRPfuzhXKkgGcZ7nAPY98NQHkct5gWRlFFtSIg
         xtvVSKqDsX0iQ==
Date:   Sat, 16 Jan 2021 11:50:49 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de, jmattson@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        corbet@lwn.net
Subject: Re: [RFC PATCH 00/23] KVM SGX virtualization support
Message-ID: <YAK2+d0OFFbo9uJ0@kernel.org>
References: <cover.1609890536.git.kai.huang@intel.com>
 <2422737f6b0cddf6ff1be9cf90e287dd00d6a6a3.camel@kernel.org>
 <20210112141428.038533b6cd5f674c906a3c43@intel.com>
 <X/0DRMx7FC5ssg0p@kernel.org>
 <20210112150756.f3fb039ac1bb176262da5e52@intel.com>
 <a522e6bd7bc588775eab889896dadac5e52eb717.camel@intel.com>
 <YAKyfrrl6AlWIQhw@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAKyfrrl6AlWIQhw@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Jan 16, 2021 at 11:31:49AM +0200, Jarkko Sakkinen wrote:
> On Sat, Jan 16, 2021 at 03:43:18AM +1300, Kai Huang wrote:
> > On Tue, 2021-01-12 at 15:07 +1300, Kai Huang wrote:
> > > > > > > 
> > > > > > > To support virtual EPC, add a new misc device /dev/sgx_virt_epc to SGX
> > > > > > > core/driver to allow userspace (Qemu) to allocate "raw" EPC, and use it as
> > > > > > > "virtual EPC" for guest. Obviously, unlike EPC allocated for host SGX
> > > > > > > driver,
> > > > > > > virtual EPC allocated via /dev/sgx_virt_epc doesn't have enclave
> > > > > > > associated,
> > > > > > > and how virtual EPC is used by guest is compeletely controlled by guest's
> > > > > > > SGX
> > > > > > > software.
> > > > > > 
> > > > > > I think that /dev/sgx_vepc would be a clear enough name for the device. This
> > > > > > text has now a bit confusing "terminology" related to this.
> > > > > 
> > > > > /dev/sgx_virt_epc may be clearer from userspace's perspective, for instance,
> > > > > if people see /dev/sgx_vepc, they may have to think about what it is,
> > > > > while /dev/sgx_virt_epc they may not.
> > > > > 
> > > > > But I don't have strong objection here. Does anyone has anything to say here?
> > > > 
> > > > It's already an abberevation to start with, why leave it halfways?
> > > > 
> > > > Especially when three remaining words have been shrunk to single
> > > > characters ('E', 'P' and 'C').
> > > > 
> > > 
> > > I have expressed my opinion above. And as I said I don't have strong objection
> > > here. I'll change to /dev/sgx_vepc if no one opposes.
> > 
> > Hi Jarkko,
> > 
> > I am reluctant to change to /dev/sgx_vepc now, because there are lots of
> > 'sgx_virt_epc' in the code.  For instance, 'struct sgx_virt_epc', and function names
> > in sgx/virt.c are all sgx_virt_epc_xxx(), which has 'sgx_virt_epc' as prefix. I feel
> > changing to /dev/sgx_vepc only is kinda incomplete, but I really don't want to change
> > so many 'sgx_virt_epc' to 'sgx_vepc'. 
> > 
> > (Plus I still think  'virt_epc' is more obvious than 'vepc' from userspace's
> > perspective.)
> > 
> > Does it make sense?
> 
> We can reconsider naming later on for sure, and maybe it's better to do
> so. It's probably too early to define the final name.
> 
> As far as naming goes, I'm actually wondering is this usable outside of
> KVM by any means? If not, then probably the best name for this device
> would be sgx_kvm_epc. Better to be always as explicit as possible.

You can easily do such renames with git filter-branch over a patch set:

https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History

Having to rename something in too many places is not an argument.
Considering it too early is.

/Jarkko
