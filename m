Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 332D5C4338F
	for <linux-sgx@archiver.kernel.org>; Wed, 11 Aug 2021 00:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0995261058
	for <linux-sgx@archiver.kernel.org>; Wed, 11 Aug 2021 00:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235742AbhHKATf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 10 Aug 2021 20:19:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235692AbhHKATe (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 10 Aug 2021 20:19:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7607E60F55;
        Wed, 11 Aug 2021 00:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628641152;
        bh=Zc5dExTPRWUtgOfGNOxttYI0bTWbZetNAgPIsuEtZWA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GIFjD92s9zH7DeIlDYvhYE2t3gAV+mpD0/QyBwwj5tG4K8F9p7zo42W73BWqEGaOI
         6GUzE41nQ/sj99dq6k2ODuHl9zsmyOF88XQkfD9yCi62IuXwjBpaGuLgOj0Gv6IS65
         IzbRToSw7A0wE+4SvD7MfvmA+heWLVflfSDdG+Tg0sbpdl7onNwluD7nMb6/wFYmgb
         zpzW8M3zFIuSlXniaat46GMIzHo+ICKVj9RVUewB4JycIgwvqxYlJGtzBkaVlTxMEg
         XUBkObLjxcvDnhLzA5q2yUFWV9ZaEnJhWeb309Sc21YbwQOYyIglkA9ZOoBHg830Hs
         WGGVGp0LCXBlg==
Date:   Wed, 11 Aug 2021 03:19:09 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Always deregister /dev/sgx_provision on failure
Message-ID: <20210811001909.wjagzcapjqv7sfrx@kernel.org>
References: <20210810225627.202890-1-jarkko@kernel.org>
 <20210811112713.267a1d0b99ee53813ba733b3@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811112713.267a1d0b99ee53813ba733b3@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Aug 11, 2021 at 11:27:13AM +1200, Kai Huang wrote:
> On Wed, 11 Aug 2021 01:56:27 +0300 Jarkko Sakkinen wrote:
> > When /dev/sgx_vepc for KVM was added, the initialization was relaxed so
> > that this file can be accessed even when the driver is disabled.
> > 
> > Deregister /dev/sgx_provision when the driver is disabled, because it is
> > only useful for the driver.
> 
> Hi Jarkko,
> 
> This is not true.  KVM also uses /dev/sgx_provision to restrict enclave in guest
> from accessing provisoning key.  Specifically, in order to allow guest enclave
> to be able to use provisioning key, when one VM is created, Qemu must have
> permission to open /dev/sgx_provision, and pass the fd as parameter to
> KVM_CAP_SGX_ATTRIBUTE.
> 
> Please see below KVM API:
> 
> 7.25 KVM_CAP_SGX_ATTRIBUTE
> --------------------------           
>                                                      
> :Architectures: x86                                         
> :Target: VM                                                              
> :Parameters: args[0] is a file handle of a SGX attribute file in securityfs
> :Returns: 0 on success, -EINVAL if the file handle is invalid or if a requested
>           attribute is not supported by KVM.                         
>                                                                                
> KVM_CAP_SGX_ATTRIBUTE enables a userspace VMM to grant a VM access to one or
> more priveleged enclave attributes.  args[0] must hold a file handle to a valid
> SGX attribute file corresponding to an attribute that is supported/restricted
> by KVM (currently only PROVISIONKEY).
>                                                                     
> The SGX subsystem restricts access to a subset of enclave attributes to provide
> additional security for an uncompromised kernel, e.g. use of the PROVISIONKEY
> is restricted to deter malware from using the PROVISIONKEY to obtain a stable
> system fingerprint.  To prevent userspace from circumventing such restrictions
> by running an enclave in a VM, KVM prevents access to privileged attributes by
> default.                                                 

OK, I was not aware of this.

/Jarkko
