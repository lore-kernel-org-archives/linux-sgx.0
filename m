Return-Path: <SRS0=PKbn=UR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD3D6C31E51
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Jun 2019 13:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9077920823
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Jun 2019 13:38:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="dam2Qm8L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbfFRNiu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Jun 2019 09:38:50 -0400
Received: from usfb19pa13.eemsg.mail.mil ([214.24.26.84]:54137 "EHLO
        USFB19PA13.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfFRNiu (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 18 Jun 2019 09:38:50 -0400
X-EEMSG-check-017: 275017815|USFB19PA13_EEMSG_MP9.csd.disa.mil
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by USFB19PA13.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 18 Jun 2019 13:38:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1560865119; x=1592401119;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=kjHoGoiqcXOAjLtYcHtuy6pY//04cO8oP6CdXhAP6Os=;
  b=dam2Qm8LBh4Jj+rJxD5CoB3lMB+lhxyICA2X8AyXqqQgnS9A8w+jS4q+
   p4lSRhqXkt2spM9QZgGrPynP4+SgZqCI3+pNWaQhJUTZc1iQh3eyfriTV
   Slu1BD9ja84/2dEUrFXXFnybq3Gtwc4CP6lrjLmKPiekLRSfT2Aj1hlZj
   SRB/FXPE5Ngp8hNIquCOCrP/ln44KCW6lyxPDh63EHytL6a5xDxcr2yKu
   zoqdxSfFzPwVGq7SsIski4wjco2+9VQezaxB6bKBLmBJT9akmKULHxAB2
   ycCFC03vT2EjxC0d8qgK2dx6HBRLU75bXt/BFO4c9KpfRDINJzLuu948F
   A==;
X-IronPort-AV: E=Sophos;i="5.63,389,1557187200"; 
   d="scan'208";a="24848741"
IronPort-PHdr: =?us-ascii?q?9a23=3A73GmVB2dzzfnPxz0smDT+DRfVm0co7zxezQtwd?=
 =?us-ascii?q?8ZsesVI/rxwZ3uMQTl6Ol3ixeRBMOHsqgC07Kd6PyoGTRZp8rY6TZaKN0Efi?=
 =?us-ascii?q?RGoP1epxYnDs+BBB+zB9/RRAt+Iv5/UkR49WqwK0lfFZW2TVTTpnqv8WxaQU?=
 =?us-ascii?q?2nZkJ6KevvB4Hdkdm82fys9J3PeQVIgye2ba9vIBmsogjdq9cajZF+JqotxR?=
 =?us-ascii?q?fErHRFcPlSyW90OF6fhRnx6tqt8JJ57yhcp/ct/NNcXKvneKg1UaZWByk8PW?=
 =?us-ascii?q?Av483ruxjDTQ+R6XYZT24bjBlGDRXb4R/jRpv+vTf0ueR72CmBIM35Vqs0Vi?=
 =?us-ascii?q?i476dqUxDnliEKPCMk/W7Ni8xwiKVboA+9pxF63oXZbp2ZOOZ4c6jAZt4RW3?=
 =?us-ascii?q?ZPUdhNWCxAGoO8bpUAD+wdPeZDsoLxo0ICoQaiCQWwAe/izDFHhmXy3aYnze?=
 =?us-ascii?q?ovFw/I1xEkE94XrnjZqND5OaEPWu630abI1y3OYe5I1zfz6IbGcR4vrv+DUr?=
 =?us-ascii?q?1ybcXfxlIiFx/Hg1iKtYDpIz2Y2+YLvmOG7+RgT+Wvi2s/pg9svjig2N8sio?=
 =?us-ascii?q?nXiYIT11vK6CB5z5wxJd28VkF6YcOvHZxLty6HLIt7Wd8iQmF0tyY6zb0Ko5?=
 =?us-ascii?q?i7fDMQx5g9yB7fbOKHfpGO7xn+WuiRJjJ4i2hkeLK5nxuy8lavyvf6Vsaq1F?=
 =?us-ascii?q?ZGtC1FksPDtnwV2BzT69SHSvtg/ki6wzqAywfT6uRCLEsplqTbM4YszqM/m5?=
 =?us-ascii?q?ccq0jOHjL6lF/ogKKZaEko4PWk5uL6abv8vJCcLZV7igTmP6QrncywHPo3Px?=
 =?us-ascii?q?AVX2ie5eS8zLrj/VDlQLlSjv05jK3ZsJfCKMQHvKG5GQ5V0ps46xqlEzen0M?=
 =?us-ascii?q?gXnXkALF5ffhKIk5PpNE3ULPD9DPe/h0ygkDZtx//YIr3sGojBI3fMnbv7fb?=
 =?us-ascii?q?tx9lRQxBQ8wNxB/Z5YF6kNIPfpVU/wsNzYAAU5Mwuxw+v/E9Vyy5geVHmTAq?=
 =?us-ascii?q?6ZLKzSsViI6vgpI+mXfoAZojn9K/875/L2l382hUcdfbW13ZsQcH24BeppLF?=
 =?us-ascii?q?+fYXb2gNcNC3sFvgokTOzrk12CTTlTZ26yX60i/DE7E4WmDYHYS4CshryBwD?=
 =?us-ascii?q?m0HplMam9aDVCMFG/id5+YVPcUdCKSPshhnyQGVbe7UY8h1hKutAjgx7p8NO?=
 =?us-ascii?q?XU+S4YtZPl1Ndr4e3ejhUy9T1yD8SA3GCBVWB0nmUURzAo2KBzu1ByylCG0a?=
 =?us-ascii?q?JgmfxXCcRT5+9VUgc9LZPcy+16C9bvWgPOZ9uJU1mmQ9q9DDEvQdI+3cUOb1?=
 =?us-ascii?q?x+G9q8lBDD2TSlA7sPm7yMHpw0/brW32LtKMZl13bGyK4hgkE7TcRVK22pmL?=
 =?us-ascii?q?Rz9wjJCI7PiEWWiaCqeL8d3C7L6GeM026OsFtEXw53VKXPRWofaVfOrdTl+k?=
 =?us-ascii?q?PCSKejBqg5PQRc086CK7dFZsfmjFVHQvfjN8/TY2O3m2esGxmIwqmAY5bte2?=
 =?us-ascii?q?UYxC/dElQLkxgP/XaaMggzHiOho3/CDDxpDl/vYF3j8fN4qHylSk841QaKb1?=
 =?us-ascii?q?du17Ct4B4ameScS+8P3rIDoCohqSt7HEq939LMDNqNvARhfKJGYdMh+lhH02?=
 =?us-ascii?q?PZtgNnMpO8KKBig0YUcx5rsEP2yxV3FoJAnNAlrHMw0gVyJrmV301HdzOaw5?=
 =?us-ascii?q?/wPrnXKmju8xy1d6HW3VTeg56q/fI05f0+437jpgCyCk0683h9yN5Tmy+H65?=
 =?us-ascii?q?zMSghUWpLrU10r8AB6qqvBZS8V5oXI2HkqOq6x5HuK+dszB+gigi2pfNReNq?=
 =?us-ascii?q?6CXFvwGtcZBM/oM+UpmFmvYxQsOOFU6b5yPsW6ev/A06muarVOhjWj2F9b7Z?=
 =?us-ascii?q?h930TEzC91TurFzt5R2P2D9heWXDf7ylG6u4b4np4SNmJaJXa21SWxXN0ZXa?=
 =?us-ascii?q?Z1Z4teTD70csA=3D?=
X-IPAS-Result: =?us-ascii?q?A2AzAADo5whd/wHyM5BmGwEBAQEDAQEBBwMBAQGBVAMBA?=
 =?us-ascii?q?QELAYFmKmpRATIohBaTRwEBAQaBNYlTkQwJAQEBAQEBAQEBLQcBAgEBhEACg?=
 =?us-ascii?q?lEjNwYOAQMBAQEEAQEBAQMBAWwcDII6KQGCZgEBAQECASMEEUEQCxgCAiYCA?=
 =?us-ascii?q?lcGAQwGAgEBgl8/AYF2BQ8PqTR+M4QyAYEUgyGBQAaBDCgBi10XeIEHgREng?=
 =?us-ascii?q?ms+gmEChGuCWASLSg87gXmGHIEplA4JghKCG4QtjQUGG4InixCFe4QCjR2BL?=
 =?us-ascii?q?IV4kVEigVgrCAIYCCEPgycThWyFFIVbIwMwAQEBAYECAQGMHyuCJQEB?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 18 Jun 2019 13:38:37 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x5IDcJmM018305;
        Tue, 18 Jun 2019 09:38:36 -0400
Subject: Re: [RFC PATCH v3 00/12] security: x86/sgx: SGX vs. LSM, round 3
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <05bcc1e2-0bd7-dcb9-02c3-969f4484a5fc@tycho.nsa.gov>
Date:   Tue, 18 Jun 2019 09:38:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190617222438.2080-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/17/19 6:24 PM, Sean Christopherson wrote:
> My original plan was for my next RFC to be an implementation of Andy's
> proposed "dynamic tracking" model.  I actually finished the tracking
> portion, but was completely flummoxed by the auditing[1].  Since Cedric's
> RFC is essentially a variation of the dynamic tracking model, it too has
> the same auditing complexities.  End result, I ended back at the "make
> userspace state its intentions" approach.
> 
> Except for patch 12 (see below), the SGX changes have been fully tested,
> including updating the kernel's selftest as well as my own fork of (an old
> version of) Intel's SDK to use the new UAPI.  The LSM changes have been
> smoke tested, but I haven't actually configured AppArmor or SELinux to
> verify the permissions work as intended.

Was dropping linux-security-module and selinux lists intentional for 
this RFC? Not recommended.

Is the entire series aside from patch 12 available in a public tree 
somewhere?

Ultimately we'll want additions to the selinux-testsuite that exercise 
each of the new permissions, both a permission denied scenario and a 
permission allowed scenario.

> 
> Patches 1-3 are bug fixes that should go into v21 regardless of what we
> end up doing for LSM support.  They're included here as the actual LSM
> RFC patches are essentially untestable without them.
> 
> Patches 4-11 are the meat of the RFC.
> 
> Patch 12 is purely to show how we might implement SGX2 support.  It's not
> intended to be included in v21.
> 
> 
> This series is a delta to Jarkko's ongoing SGX series and applies on
> Jarkko's current master at https://github.com/jsakkine-intel/linux-sgx.git:
> 
>    4cc5d411db1b ("docs: x86/sgx: Document the enclave API")
> 
> The basic gist of the approach is to track an enclave's page protections
> separately from any vmas that map the page, and separate from the hardware
> enforced protections.  The SGX UAPI is modified to require userspace to
> explicitly define the protections for each enclave page, i.e. the ioctl
> to add pages to an enclave is extended to take PROT_{READ,WRITE,EXEC}
> flags.
> 
> An enclave page's protections are the maximal protections that userspace
> can use to map the page, e.g. mprotect() and mmap() are rejected if the
> protections for the vma would be more permissible than those of the
> associated enclave page.
> 
> Tracking protections for an enclave page (in additional to vmas) allows
> SGX to invoke LSM upcalls while the enclave is being built.  This is
> critical to enabling LSMs to implement policies for enclave pages that
> are functionally equivalent to existing policies for normal pages.
> 
> 
> [1] https://lkml.kernel.org/r/20190614003759.GE18385@linux.intel.com
> 
> v1: https://lkml.kernel.org/r/20190531233159.30992-1-sean.j.christopherson@intel.com
> 
> v2: https://lkml.kernel.org/r/20190606021145.12604-1-sean.j.christopherson@intel.com
> 
>    - Dropped the patch(es) to extend the SGX UAPI to allow adding multiple
>      enclave pages in a single syscall [Jarkko].
> 
>    - Reject ioctl() immediately on LSM denial [Stephen].
> 
>    - Rework SELinux code to avoid checking EXEMEM multiple times [Stephen].
> 
>    - Adding missing equivalents to existing selinux_file_protect() checks
>      [Stephen].
> 
>    - Hold mmap_sem across copy_to_user() to prevent a TOCTOU race when
>      checking the source vma [Stephen].
> 
>    - Stubify security_enclave_load() if !CONFIG_SECURITY [Stephen].
> 
>    - Make flags a 32-bit field [Andy].
> 
>    - Don't validate the SECINFO protection flags against the enclave
>      page's protection flags [Andy].
> 
>    - Rename mprotect() hook to may_mprotect() [Andy].
> 
>    - Test 'vma->vm_flags & VM_MAYEXEC' instead of manually checking for
>      a noexec path [Jarkko].
> 
>    - Drop the SGX defined flags (use PROT_*) [Jarkko].
> 
>    - Improve comments and changelogs [Jarkko].
> 
> v3:
>    - Clear VM_MAY* flags instead of using .may_mprotect() to enforce
>      maximal enclave page protections.
> 
>    - Update the SGX selftest to work with the new API.
> 
>    - Rewrite SELinux code to use SGX specific permissions, with the goal
>      of addressing Andy's feedback regarding what people will actually
>      care about when it comes to SGX, e.g. add permissions for restricing
>      unmeasured code and stop trying to infer permissions from the source
>      of each enclave page.
> 
>    - Add a (very minimal) AppArmor patch.
> 
>    - Show line of sight to SGX2 support.
> 
>    - Rebased to Jarkko's latest code base.
> 
> Sean Christopherson (12):
>    x86/sgx: Add mm to enclave at mmap()
>    x86/sgx: Do not naturally align MAP_FIXED address
>    selftests: x86/sgx: Mark the enclave loader as not needing an exec
>      stack
>    x86/sgx: Require userspace to define enclave pages' protection bits
>    x86/sgx: Enforce noexec filesystem restriction for enclaves
>    mm: Introduce vm_ops->may_mprotect()
>    LSM: x86/sgx: Introduce ->enclave_map() hook for Intel SGX
>    security/selinux: Require SGX_EXECMEM to map enclave page WX
>    LSM: x86/sgx: Introduce ->enclave_load() hook for Intel SGX
>    security/selinux: Add enclave_load() implementation
>    security/apparmor: Add enclave_load() implementation
>    LSM: x86/sgx: Show line of sight to LSM support SGX2's EAUG
> 
>   arch/x86/include/uapi/asm/sgx.h          |  5 +-
>   arch/x86/kernel/cpu/sgx/driver/ioctl.c   | 69 +++++++++++------
>   arch/x86/kernel/cpu/sgx/driver/main.c    | 94 +++++++++++++++++++++++-
>   arch/x86/kernel/cpu/sgx/encl.c           | 81 ++++++++++++--------
>   arch/x86/kernel/cpu/sgx/encl.h           |  7 +-
>   include/linux/lsm_hooks.h                | 20 +++++
>   include/linux/mm.h                       |  2 +
>   include/linux/security.h                 | 18 +++++
>   mm/mprotect.c                            | 15 +++-
>   security/apparmor/include/audit.h        |  2 +
>   security/apparmor/lsm.c                  | 14 ++++
>   security/security.c                      | 12 +++
>   security/selinux/hooks.c                 | 72 ++++++++++++++++++
>   security/selinux/include/classmap.h      |  6 +-
>   tools/testing/selftests/x86/sgx/Makefile |  2 +-
>   tools/testing/selftests/x86/sgx/main.c   | 32 +++++++-
>   16 files changed, 384 insertions(+), 67 deletions(-)
> 

