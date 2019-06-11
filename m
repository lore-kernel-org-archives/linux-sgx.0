Return-Path: <SRS0=yZGw=UK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A88F2C4321A
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Jun 2019 17:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75BD92089E
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Jun 2019 17:21:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="P18/txjR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405786AbfFKRVe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 11 Jun 2019 13:21:34 -0400
Received: from upbd19pa10.eemsg.mail.mil ([214.24.27.85]:48533 "EHLO
        upbd19pa10.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405263AbfFKRVd (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 11 Jun 2019 13:21:33 -0400
X-EEMSG-check-017: 231871982|UPBD19PA10_EEMSG_MP10.csd.disa.mil
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by upbd19pa10.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 11 Jun 2019 17:21:26 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1560273689; x=1591809689;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=vxQAKwcRxRcL+ZP+B7Dv4bbFiJgV34hud+MdCjYE7tM=;
  b=P18/txjRrsUEXLSCwFMxARNNBvj9GmKjR4iUdDKw2Q5l06vlWDjbOs6v
   PfKwh6+jG3XEGbhr37mwbcLwtOzrHxZg2oK+0+PT1DbRyZ3paXDuH4YW9
   5Xct64qXIPLqDccCyhn2eLI87y1rMZ4r08ffChC1Q/PjcO2YLGoH3FZG0
   1p0X5tK6QkRyCvs5o7DrzFANjBmqzcvKEhvLA2s8LBb0noDsbzTYvupIN
   ndq8UECxqeq7p/T1RhbqCNPSTfRCTjLDSzBz8VgqQDy52E8OTFMsbjcif
   THbc0six9IRfWzNxr/VQhwdZBc9wljpXZgmIXL3J4uWTKL5Xkomk4/doL
   g==;
X-IronPort-AV: E=Sophos;i="5.63,362,1557187200"; 
   d="scan'208";a="28829686"
IronPort-PHdr: =?us-ascii?q?9a23=3AXyWwjhbic2/iPgD+t18shRH/LSx+4OfEezUN45?=
 =?us-ascii?q?9isYplN5qZpcq9YR7h7PlgxGXEQZ/co6odzbaP6ua5BDFLsM3JmUtBWaQEbw?=
 =?us-ascii?q?UCh8QSkl5oK+++Imq/EsTXaTcnFt9JTl5v8iLzG0FUHMHjew+a+SXqvnYdFR?=
 =?us-ascii?q?rlKAV6OPn+FJLMgMSrzeCy/IDYbxlViDanbr5+MQi6oR/MusQWgYZuJaI8xx?=
 =?us-ascii?q?XUqXZUZupawn9lK0iOlBjm/Mew+5Bj8yVUu/0/8sNLTLv3caclQ7FGFToqK2?=
 =?us-ascii?q?866tHluhnFVguP+2ATUn4KnRpSAgjK9w/1U5HsuSbnrOV92S2aPcrrTbAoXD?=
 =?us-ascii?q?mp8qlmRAP0hCoBKjU063/chNBug61HoRKhvx1/zJDSYIGJL/p1Y6fRccoHSW?=
 =?us-ascii?q?ZdQspdUipMDY2mb4sLEuEPI+BWoYfgrFcKtBezCw2hCObpxzRVhHH5wLc63v?=
 =?us-ascii?q?w8Hw/Y0gwuH9EAvnrao9r6NqgdTe+7wbLUzTjBdf5axSvx5YbKfx0nvPqCXa?=
 =?us-ascii?q?hwcc3UyUQ3Cg3FkkufqZTlPzyL0OQGrnWV7+96WuKrj24otQFwqSWoy8c3l4?=
 =?us-ascii?q?bJnZkYykzE9CplwIY1Ise0SEhgYdG+CpdQuCaaN5VvT84kXmpmuz46x6UbtZ?=
 =?us-ascii?q?O0cyUG0pQqywPFZ/CZfIWE/AjvWPuXLDxlnnxqYqi/iAy38UW4z+38UdS730?=
 =?us-ascii?q?hSoypel9nMqmgN1xvO6sibUvd9/lmu2TKI1w3L9uFLO1o0lavGK5462LIwip?=
 =?us-ascii?q?oSvljDHi/xgkn2irOZdl449eSy7uTnY7HmqoedN49ylA7+LrwjltGwDOk3KA?=
 =?us-ascii?q?QDX3WX9f6i2LDs40H1WqhGguUzkqbDsZDaIcobprS+Aw9Qyosj8AuwDyy93d?=
 =?us-ascii?q?QEnXgIMFJFeBWdg4jvIFHBOur0Dfi4g1SyiDtr3ezJPqX9ApXRKXjOiLPhfa?=
 =?us-ascii?q?th605b0wczzs5Q54hSCr4fJPL/QEjxtMbXDhUhKQy73/7nCMlh1oMZQW+PAL?=
 =?us-ascii?q?WWMLnRsV+L4eIjOfKMa5UWuDb+Kvgl4eDhjXkilF8ZfKmp24YXaX+iEvRnJU?=
 =?us-ascii?q?WZfWTjgtMbHWgWuQo+SfTgiEeeXj5Le3ayQ6U86ykgCI24F4jDQJqhgL6b0C?=
 =?us-ascii?q?inHp1WfGFGCkuQEXfvb4WEW+kDaDiJIs9mlDwJTrmhS4k91R6wsA/20aZoLu?=
 =?us-ascii?q?3R+icAr5LsyMB15/HPlRE17TF7E9qS3HyXT2F1gmwEXTA33KF5oUxy0VqD0K?=
 =?us-ascii?q?54g+BGGtxX/f9GTgA6NZvExexgF9/yQh7BfsuOSFu+QNWmBDYxTsgrw98PeE?=
 =?us-ascii?q?ZwANOigQrG3yW0Ar8ZjbuLBIY78qjExXj+O959y2ra1Kkml1QmWdVANXephq?=
 =?us-ascii?q?Fh7AXTB5TGk0Gdl6eqc6QQxjLC9GCGzWCWpkFXTBZwUbnZXXAYfkbWqdX55k?=
 =?us-ascii?q?XfT76hELgnKRVOxtKfKqtQa93pkVVHSO7mONTZfm2xhmOwCgiTy7OSY4rlZX?=
 =?us-ascii?q?8d0D/eCEcaiQAT+2iJNQwkCiemuWLeAyRkFUjzbEP07el+tHS7Q1cszw6Qck?=
 =?us-ascii?q?1h06G4+gYPivyBT/Mfx7cEuCAmqzVuAlmxxc7ZC92FpwB5ZqVTfcs94Etb1W?=
 =?us-ascii?q?LerwFyIISgILp4hl4faAR6pFvu2A9tCoVBisgqtHcqwxBuJq2Gyl9BcCmY3Z?=
 =?us-ascii?q?/oML3NNmby5Ayva7LR2lzGy9aZ5KMP6PU+q1X+swCkDVQi83p53NlPyXec5Y?=
 =?us-ascii?q?vFDBAUUZ3vVkY77R96p6vVYiMl/YPbyWVsMbWosj/Fw98pBvUqygqgf9dFN6?=
 =?us-ascii?q?OJDwHyE8oAB8iyMuMqnVmpbx0eMO9O8640Otusd+Ga166zIOZggDWmgHxa74?=
 =?us-ascii?q?9nzEKD6TBwSu7S0JYD2PGXwA2HWiz9jFenrsD4h4REaSsOEWq4zCjuHJRRab?=
 =?us-ascii?q?FqfYYXFWeuJNW6xslxh57pVH9V71qjB1IA2M+0ZRqSdVv93QtR1UUYu3CohD?=
 =?us-ascii?q?W3xSRukz41tqqfwDDOw+P6eRobPW5LXndigk3oIYeplNAXR0yobwkvlBu46k?=
 =?us-ascii?q?f23qZbpKNiL2nVXEhHZTT2L2BlUqu2rLaCZNRP6JwwuyVNTOu8eUyaSqL6ox?=
 =?us-ascii?q?YC1yPjHm1exC00dj2zuZX2gQZ6iGSDI3Z3t3fZZ85wygnF5NDGRv5ewCAGRC?=
 =?us-ascii?q?9mhjnTHFS8OMOp/dqMnZfZru++T36hVoFUcSTzwoKNtyq26HZpARKhhfCznM?=
 =?us-ascii?q?PoEQwg3S/8zdlqWj3CrAzgbYnzy6S6LeVnc1FsBF/97cp6B45/npIrhJEf1n?=
 =?us-ascii?q?kXnYuV/XUZnmfpK9lb2rzxbGALRTEVx97Z+g/l2FdsLniR3YL2Sm2dwtd9Z9?=
 =?us-ascii?q?m9em4ZwCE979hPCKqP6LxEnC11oke3rA7Ib/h9mSodyf0z53EAn+EJuQ0tzi?=
 =?us-ascii?q?OHDrAVB0lYMjTmlw6U4NCmsKVXeGGvfKC21Ep+mtChFrSCrRtaWHviYJctAz?=
 =?us-ascii?q?J/7sVlP1LQynH89obkeNzIZ9IJqhKUiwvAj/RSKJ8pkPoKnS9nNn7hsnI/z+?=
 =?us-ascii?q?47iQFu3ZShsYidNWpi4aK5DQRENjHve8wT/TTth75EnsmKx4CvAolhGjITUZ?=
 =?us-ascii?q?vzU/2oCj0Suur9OwmUEDw8rWqbGbzEEA+e7kdms2zAE5SxO36LI3kZyM1oRA?=
 =?us-ascii?q?OBK0xHnAAUQDI6k4YiFgCq3sPgcF115jML6V7kqxpA0+NpOAP6UmfevgelcT?=
 =?us-ascii?q?Y0SJ6DLBVI6gFO/VvaMcub7uhrBSFX4oWhrBCRKmycfwlIDXsGWk2YB1/5Ob?=
 =?us-ascii?q?mi/9nA8/WCCeq4IPvDerSOqepCV/iWwZKjyJdp/zGJNs+XJHltE+U72lZfXX?=
 =?us-ascii?q?B+A8nWgTMPRDENlyLMb8+Xvgy8+i1pocCh7PvrWBzg5Y2MC7tVKthv/xG2ga?=
 =?us-ascii?q?GeN++fnip5KDBY1o8Syn/M0rQQwFkSiyR2fTm3DbsArTLNTL7XmqJPDB4UcS?=
 =?us-ascii?q?JzONFT76IixAZNOcjbh8j01r5+kv46FVNFWUb9lcGuYMwAO3u9O0/fBEaXKL?=
 =?us-ascii?q?SGIiXGzNrvYa6nU7JQiORUuAO2uTuYCUPsIyqMnSHzVx+zKeFMkD2bPBtGtY?=
 =?us-ascii?q?G/dRZtEmjjQcnkah28K993jSE2wac1hnPSMW4TLyR8c19Xor2X9yNYje11G3?=
 =?us-ascii?q?Zd4Xp9MemEhyGZ4vHbKpkMsPtnGCR0l/9A73Q8xLtY9yBERPppmCTMqt5iuU?=
 =?us-ascii?q?2pku6KyjB/ShpBti5LhJ6XvUVlIajZ7JhAVmjC/BIR72WfFQ8KqsBqCt3ovK?=
 =?us-ascii?q?BQxdzPm7zpJDhe9NLU+NMWB9LIJ8KfLHohLR3pFSbaDQsEST6rMWDfiFZYkP?=
 =?us-ascii?q?2I6nKZtII6qp/3l5UQUL9bSEc1G+gbCkRjANwNPpN3Uik4nr6cic4C/WC+ow?=
 =?us-ascii?q?XJRMVGopDHUeqfAe3vKDaYiblEZgMIzanjIogJKo37wU1iZUVmk4vQAEfQXN?=
 =?us-ascii?q?ZNojF/YQ8wuklC7H9+Tmhgk37iPyqr7G5bMeOomRs3kBB9YKx58Crw5H80K0?=
 =?us-ascii?q?DMqS92l1M+z5GtozmLcz32ZJy5XoJXDSfy/xwzO4n4QAEzdgSxnk1iOTHsQ7?=
 =?us-ascii?q?NXkqsmdGZ3hQuaspxKT61yV6pBNSQMyOmXavNg6lFVriGq1AcT/ufeIYdznw?=
 =?us-ascii?q?stN5i3pjRP3Bw1P419HrDZOKcclgsYvamJpCL9k7lqkQI=3D?=
X-IPAS-Result: =?us-ascii?q?A2BDBwBx4v9c/wHyM5BmHAEBAQQBAQcEAQGBZYFnKoE8M?=
 =?us-ascii?q?iiEFZM/AQEBAQEBBoEILYlRkQsJAQEBAQEBAQEBNAECAQGEQAKCfiM4EwEDA?=
 =?us-ascii?q?QEBBAEBAQEDAQFsKII6KQGCZwEFIwQRQRALDgoCAiYCAlcGAQwGAgEBgl8/g?=
 =?us-ascii?q?XcUqXx+M4VHgyqBRoEMKItdF3iBB4E4gms+h06CNiIEjXmGFZUjCYISghuRJ?=
 =?us-ascii?q?AYblyKNFphNIYFYKwgCGAghD4MnghsXFI4oIwMwAYEFAQGPXAEB?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 11 Jun 2019 17:21:26 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x5BHLLkT001566;
        Tue, 11 Jun 2019 13:21:21 -0400
Subject: Re: [RFC PATCH v2 3/5] x86/sgx: Enforce noexec filesystem restriction
 for enclaves
To:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, nhorman@redhat.com,
        npmccallum@redhat.com, Serge Ayoun <serge.ayoun@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Haitao Huang <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kai Svahn <kai.svahn@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Kai Huang <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        William Roberts <william.c.roberts@intel.com>,
        Philip Tricca <philip.b.tricca@intel.com>
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
 <20190606021145.12604-4-sean.j.christopherson@intel.com>
 <20190610160005.GC3752@linux.intel.com>
 <CALCETrVovr8XNZSroey7pHF46O=kj_c5D9K8h=z2T_cNrpvMig@mail.gmail.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <26420c42-ac7c-e2d0-ee99-d186c918ae1e@tycho.nsa.gov>
Date:   Tue, 11 Jun 2019 13:21:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CALCETrVovr8XNZSroey7pHF46O=kj_c5D9K8h=z2T_cNrpvMig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/10/19 12:44 PM, Andy Lutomirski wrote:
> On Mon, Jun 10, 2019 at 9:00 AM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
>>
>> On Wed, Jun 05, 2019 at 07:11:43PM -0700, Sean Christopherson wrote:
>>> +             goto out;
>>> +     }
>>> +
>>> +     /*
>>> +      * Query VM_MAYEXEC as an indirect path_noexec() check (see do_mmap()),
>>> +      * but with some future proofing against other cases that may deny
>>> +      * execute permissions.
>>> +      */
>>> +     if (!(vma->vm_flags & VM_MAYEXEC)) {
>>> +             ret = -EACCES;
>>> +             goto out;
>>> +     }
>>> +
>>> +     if (copy_from_user(dst, (void __user *)src, PAGE_SIZE))
>>> +             ret = -EFAULT;
>>> +     else
>>> +             ret = 0;
>>> +
>>> +out:
>>> +     up_read(&current->mm->mmap_sem);
>>> +
>>> +     return ret;
>>> +}
>>
>> I would suggest to express the above instead like this for clarity
>> and consistency:
>>
>>                  goto err_map_sem;
>>          }
>>
>>          /* Query VM_MAYEXEC as an indirect path_noexec() check
>>           * (see do_mmap()).
>>           */
>>          if (!(vma->vm_flags & VM_MAYEXEC)) {
>>                  ret = -EACCES;
>>                  goto err_mmap_sem;
>>          }
>>
>>          if (copy_from_user(dst, (void __user *)src, PAGE_SIZE)) {
>>                  ret = -EFAULT;
>>                  goto err_mmap_sem;
>>          }
>>
>>          return 0;
>>
>> err_mmap_sem:
>>          up_read(&current->mm->mmap_sem);
>>          return ret;
>> }
>>
>> The comment about future proofing is unnecessary.
>>
> 
> I'm also torn as to whether this patch is needed at all.  If we ever
> get O_MAYEXEC, then enclave loaders should use it to enforce noexec in
> userspace.  Otherwise I'm unconvinced it's that special.

What's a situation where we would want to allow this?  Why is it 
different than do_mmap()?



