Return-Path: <SRS0=W/GT=TR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 106E1C04AB4
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 19:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B67EB216FD
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 19:20:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="mXfuNOBB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfEQTUx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 May 2019 15:20:53 -0400
Received: from ucol19pa09.eemsg.mail.mil ([214.24.24.82]:22840 "EHLO
        ucol19pa09.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfEQTUw (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 17 May 2019 15:20:52 -0400
X-EEMSG-check-017: 854475640|UCOL19PA09_EEMSG_MP7.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.60,481,1549929600"; 
   d="scan'208";a="854475640"
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by ucol19pa09.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 17 May 2019 19:20:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1558120850; x=1589656850;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=hprle4xR92qxhbZdQl69jXPne3gJTuJTHFyccilcmtE=;
  b=mXfuNOBB8+EQUfUZAnoM3DTWOCNgAxuCgX0vAmT4u0EHF5lAws2wbB6F
   /aPaI6uK69+bfk5+8xj1QGixd5+VLa1lz3Fhb3FI7opVPmVfTdPE1Y0pV
   LKcIIeUe5OC1LsigV27b5iXt1wp0n2LiLEaAVh/pr6aDyBNwlA+/hZ7vv
   NJnCeAeZ1k7rkdkizz2NTOIghfITBgPOaXpkF6AWhCPc5v41huY18Bfjn
   RNvFaJA07u6jUbeTGCdXotsU/m7Sowj7j+OKsaMRw66ZisOAQxuzu2qVi
   om2U9tA/qYxtx4ZNYw7Mc2gIrx0462/BorZa6N/TSAHTYAarNAnoUThk6
   w==;
X-IronPort-AV: E=Sophos;i="5.60,481,1549929600"; 
   d="scan'208";a="27878923"
IronPort-PHdr: =?us-ascii?q?9a23=3AX8MMCRKqNnCv+oIvw9mcpTZWNBhigK39O0sv0r?=
 =?us-ascii?q?FitYgUL/XyrarrMEGX3/hxlliBBdydt6sdzbOO6eu5AjJIyK3CmUhKSIZLWR?=
 =?us-ascii?q?4BhJdetC0bK+nBN3fGKuX3ZTcxBsVIWQwt1Xi6NU9IBJS2PAWK8TW94jEIBx?=
 =?us-ascii?q?rwKxd+KPjrFY7OlcS30P2594HObwlSizexfK5+IA+roQnNqMUajpZuJ6gwxx?=
 =?us-ascii?q?DUvnZGZuNayH9yK1mOhRj8/MCw/JBi8yRUpf0s8tNLXLv5caolU7FWFSwqPG?=
 =?us-ascii?q?8p6sLlsxnDVhaP6WAHUmoKiBpIAhPK4w/8U5zsryb1rOt92C2dPc3rUbA5XC?=
 =?us-ascii?q?mp4ql3RBP0jioMKiU0+3/LhMNukK1boQqhpx1hzI7SfIGVL+d1cqfEcd8HWW?=
 =?us-ascii?q?ZNQsNdWipPDYOma4sEEvQPM+BWoYLgo1cCtBuzCA2pCO7p1zRGhGL53bci3u?=
 =?us-ascii?q?o8EQ/IwgIgEdEAvnvao9r6NrsdX++uwanUzjjOde9a1Svz5YXKdB0qvPGCXa?=
 =?us-ascii?q?h3ccrU0UQhCh/FgUuIqYzlITyV0PkGvXWe7+V6UeKvj3AoqgFsqTWo3ccjl5?=
 =?us-ascii?q?LJi5kJylHE6Sp5wIE1Kce+SE5ge9GoCpRQtyaEN4ZvRM4pXmJmuD4ix7Ebtp?=
 =?us-ascii?q?O2czIGxZQ6yxLFdfCKfJaE7gj+WOuXPDx2nmhqeKiliBa36UWgz+r8WdSq31?=
 =?us-ascii?q?tStSpFl8XMtmgK1xzO9siLUvt98Vml2TaIzw3T9vtLIVo1larGMJ4t2KIwl5?=
 =?us-ascii?q?oPvkTDGS/6gkP2g7ONdko44OSo7uXnYrH+qp+dMY97lB3+P7wzlsGwDuk0KA?=
 =?us-ascii?q?gDU3WB9eii27Dv41f1TKhSgv0ziKbZsZTaJcoBpq6+Bg9Yyp0j5AukDzq9zN?=
 =?us-ascii?q?QZnWUILFJCeB6diYjpIEvBLOr3Dfe4nVSgiC1ryOzePr39HpXNKWDOkLP8fb?=
 =?us-ascii?q?Zh7E5R0xA8zdVF6J1IEL4BOPPzWlPru9zcFBM5NRK7w/r/AtVnyoweQX6PAr?=
 =?us-ascii?q?OeMK7Kql+H+PggI++WaI8XojryN/gl5+TvjX8ihV8derGp3ZsJZ3CiBfRmJE?=
 =?us-ascii?q?OZbGHtgtcHDWcFoA4+QPb2h12FVD5Zf2yyUL4k5jEnFIKmCp/OSZyzj7Ocxi?=
 =?us-ascii?q?e7H4FZanpJC1CNF3foeJ6JW/YKaCKOPMBhliYIWqSmS48kzRuurhP1y6J7Lu?=
 =?us-ascii?q?rI/S0VrZbj1MVp5+3Ujhwy9iJ7D96b026TS2F4hGQIRyU53Kpnu0xy1k+D0b?=
 =?us-ascii?q?Rkg/xfDdFT5fZJUgAgNZ7Gzux6EMv/WgTbcdeMVlmmQ8+qATYrTtI+29UOeV?=
 =?us-ascii?q?pyG82+jhDf2CqnG6QVmKKRBJw77K3RxHjxKNx5y3bC1KghiUMqTddINW2jnq?=
 =?us-ascii?q?R/7RTcB5bVk0WFkKanbaAc3C/L9GeewmuCpVpYXxBsXqXYR3AfZ1fWrNTg6k?=
 =?us-ascii?q?PHSL+hFKknMg9fxsOZNKtKZcPmjU9cSPfgJtveeWSxlHm0BRqSwbOMdoXqcX?=
 =?us-ascii?q?0H3CrBEEgEjxwT/XGeOAgmHCihvmbeASd2FV31fkPs9fByqHa8Tk8z1QGFcV?=
 =?us-ascii?q?dt2Kay+h4QnfacUe8c3qoYuCc9rDV5BEiy38rMBNqapgphZ75RYcsn71dd1G?=
 =?us-ascii?q?LZrBR9Ppi6IK9+mFESaQN3v1nh1x9vEIVPjdAqrG82zAp1Ma+Yy01OdzeZ3Z?=
 =?us-ascii?q?D2J73WJXL//A6ga6HIwFHSytWW9bkV6PQ+tVrjuBulFk0483Voy9NVyWeT5o?=
 =?us-ascii?q?3WDAoOVpL8SkQ3+AJgp7HZYSk94JnY1WZ2Pqm3sT/C2tQpC/Ujyhu7e9dfMa?=
 =?us-ascii?q?WEFBL9EsEABsiuLvAqlEatbh4eIO9S86s0Ndu8d/SawK6rIPpgnDW+gGRF/o?=
 =?us-ascii?q?99zkKM9zB7SuPT0ZYFxOuY3hedWDf6jVegvdr7lpxDZTEXBmC/0zTrBJZNZq?=
 =?us-ascii?q?1ueoYGEXqhLNepxtpgnZLtW2RX9Fi4B1wY3s+kYhuSb1rh3QJO0UQbu2ComS?=
 =?us-ascii?q?y9zzZsiTEmsrKf3DDSw+TlbBcHJmFLRG1tjFr3JYi0jtYaXFW0bwgzkxul40?=
 =?us-ascii?q?f6xqdBqKtiMWbZWV1IcDTuL2F+TquwsaKPY8FV6Jw2viVaS/qzYVaYSrHjpx?=
 =?us-ascii?q?sa1yLjEHdEyD8ncDGqv43znwZmh2KFMHZzsH3ZdNlsxRfY/tzcW+Re3j4bSy?=
 =?us-ascii?q?ljkjTXAlm8P9+0/dSbjpvDvOe+V3+nVpJOaybr0YKAtCy95WFwBh2/hf+zkM?=
 =?us-ascii?q?X9EQcmyS/7y8VqVSLQoRb4Y4nr0bm6MO1+cklrGlD88cx6FZ96koYrmpEQ1m?=
 =?us-ascii?q?YVho+P8XoEj2jzK9Nb1rz6bHYXQj4L2dHV6hD/2EJ/NnKJ2575VnKFz8puZN?=
 =?us-ascii?q?S3Y3gb2iEj4MBQDqeb8rhEkTFyolqiogLbeeJ9kSsFyfsy9H4ahPkEuA4szi?=
 =?us-ascii?q?WbH7ATElBUPTfjlxWH9N2+sqpXa3i1cbSq10pxg8qhDLecrQFYQnr5fY0iHS?=
 =?us-ascii?q?Bo5MVlLF3MyGHz6p3jeNTId90TtQWUkxLbguhRKZIxkOcKhCV+NWLzun0l1u?=
 =?us-ascii?q?g7ggF00pGmvYiHLGNt8Li+Ah5COT3/f9kT9S31jaZCgsaW2JiiHpNhGjUMRp?=
 =?us-ascii?q?voSOinEDQJuPT9KQmBDT08pW2HGbbFAQCf70JmpWrVE5+3L3GXOGUZzdJ6SR?=
 =?us-ascii?q?mbPExfhRwbUykgkZ49EgCq2cnhfVxj5j8P+1H4qgFDyv5yOxbjVWffoR+iai?=
 =?us-ascii?q?0oR5iHMBpW8gZC6l/OMcOA9OJzED9X8oe7ow2NLWybegJIAHoIWkyCG1DsIL?=
 =?us-ascii?q?2u6cPc/OifA+q0N+HObqmWqexCS/eIwoqi0pBm/zmWNsSDJHpiAOcn2ktCRH?=
 =?us-ascii?q?x4Gt7WmzAOSywNjC/NbsibpAui9S1ztMyw7PPrWAf374uVF7RSKclv+wyxga?=
 =?us-ascii?q?qbN+6fnid5KSpC2ZML33PIyKUf00QUiyFhbDStELIAtTLTQ6LUgKNYExkbay?=
 =?us-ascii?q?ZrPstS8608xhVNOdLcit7tzLF4iOM6C01EVV3hgM2pfswKLH+jNFzbBEaEKr?=
 =?us-ascii?q?KGJT7Mw8zsZaO8SLtQjPhbthGquDabFVPjMSqHlzXzSx+vNuRMhjmBPBNCoI?=
 =?us-ascii?q?G9bgptCW/7QdLlcBK7McV7jSYowbIuhnPKM3URMTl6c0NRsLKQ6TlUjel4G2?=
 =?us-ascii?q?xE9nBlN/WLmz6F7+nELZYbqeBkAjxvmu1A5HQ6yqVa7CdHSfBvhSTdsMZko0?=
 =?us-ascii?q?u6nemX1jpnTB1Opy5JhIKMpkViOb7U9ptHWXbf/BIN8X+QCxUSp9thFNLvp7?=
 =?us-ascii?q?xQxsLIlKLpJzdI68jU8tcEB8jINMKHN2IsMRnzFz7VFgcFTSOrOnvZh0xSi/?=
 =?us-ascii?q?yS93uVroQkpZjogpYBVrhbVFktHPMAFktlBMACIItwXj48i76bjdAH5XyirB?=
 =?us-ascii?q?nTWspapYvKVv2VAfXoJzaZiadLawEUzrP/KIRAfrH8jmVkZkgyuJnWHE/RR8?=
 =?us-ascii?q?tOo2U1ahIop21E9XF1R3Uyx0vhLAWg/ClAO+Szm0sNlgZmYekrvAzp6lMzK0?=
 =?us-ascii?q?uC8DA8i2EtiN7lhnaXaze3I6CuC9IFQxHovlQ8Z8uoCz1+ahe/yAk9aWbJ?=
X-IPAS-Result: =?us-ascii?q?A2AWAADxCN9c/wHyM5BkGgEBAQEBAgEBAQEHAgEBAQGBV?=
 =?us-ascii?q?AIBAQEBCwGBZiqBNgUyKIQSkwtQAQEGgQgtiU6RAgkBAQEBAQEBAQE0AQIBA?=
 =?us-ascii?q?YRAAoI0IzcGDgEDAQEBBAEBAQEDAQFsKII6KQGCZwEFIw8BBUEQCw4KAgImA?=
 =?us-ascii?q?gJXBg0GAgEBgl8/gXcUqw6BL4hugUaBDCgBi1AXeIEHgREngms+h06CWASNR?=
 =?us-ascii?q?JpSCYINgg+QZgYbhDeOCoNXpBUigVcrCAIYCCEPgyeQbSMDMIEGAQGPXQEB?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 17 May 2019 19:20:49 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x4HJKkNk002830;
        Fri, 17 May 2019 15:20:46 -0400
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
From:   Stephen Smalley <sds@tycho.nsa.gov>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
        David Rientjes <rientjes@google.com>
References: <20190515013031.GF1977@linux.intel.com>
 <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
 <alpine.LRH.2.21.1905160543070.19802@namei.org>
 <CALCETrX_Q6qwNRNF0TL2tgfm1j6DKLX7NVHHmWbMFtk3WnHDKw@mail.gmail.com>
 <alpine.LRH.2.21.1905160844130.29250@namei.org>
 <CALCETrX2ovRx3Rre+1_xC-q6CiybyLjQ-gmB4FZF_qCZ-Qd+4A@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E38CD@ORSMSX116.amr.corp.intel.com>
 <CALCETrUfmyQ7ivNzQic0FyPXe1fmAnoK093jnz0i8DRn2LvdSA@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E3FB9@ORSMSX116.amr.corp.intel.com>
 <6a97c099-2f42-672e-a258-95bc09152363@tycho.nsa.gov>
 <20190517150948.GA15632@linux.intel.com>
 <ca807220-47e2-5ec2-982c-4fb4a72439c6@tycho.nsa.gov>
 <80013cca-f1c2-f4d5-7558-8f4e752ada76@tycho.nsa.gov>
 <837CE33B-A636-4BF8-B46E-0A8A40C5A563@amacapital.net>
 <6d083885-1880-f33d-a54f-23518d56b714@tycho.nsa.gov>
Message-ID: <dbaf4695-df60-3ce9-cbf7-b44d7100da2f@tycho.nsa.gov>
Date:   Fri, 17 May 2019 15:20:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <6d083885-1880-f33d-a54f-23518d56b714@tycho.nsa.gov>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/17/19 2:05 PM, Stephen Smalley wrote:
> On 5/17/19 1:12 PM, Andy Lutomirski wrote:
>>
>>
>>> On May 17, 2019, at 9:37 AM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
>>>
>>>> On 5/17/19 12:20 PM, Stephen Smalley wrote:
>>>>> On 5/17/19 11:09 AM, Sean Christopherson wrote:
>>>>>> On Fri, May 17, 2019 at 09:53:06AM -0400, Stephen Smalley wrote:
>>>>>>> On 5/16/19 6:23 PM, Xing, Cedric wrote:
>>>>>>> I thought EXECMOD applied to files (and memory mappings backed by 
>>>>>>> them) but
>>>>>>> I was probably wrong. It sounds like EXECMOD applies to the whole 
>>>>>>> process so
>>>>>>> would allow all pages within a process's address space to be 
>>>>>>> modified then
>>>>>>> executed, regardless the backing files. Am I correct this time?
>>>>>>
>>>>>> No, you were correct the first time I think; EXECMOD is used to 
>>>>>> control
>>>>>> whether a process can make executable a private file mapping that has
>>>>>> previously been modified (e.g. text relocation); it is a special 
>>>>>> case to
>>>>>> support text relocations without having to allow full EXECMEM 
>>>>>> (i.e. execute
>>>>>> arbitrary memory).
>>>>>>
>>>>>> SELinux checks relevant to W^X include:
>>>>>>
>>>>>> - EXECMEM: mmap/mprotect PROT_EXEC an anonymous mapping 
>>>>>> (regardless of
>>>>>> PROT_WRITE, since we know the content has to have been written at 
>>>>>> some
>>>>>> point) or a private file mapping that is also PROT_WRITE.
>>>>>> - EXECMOD: mprotect PROT_EXEC a private file mapping that has been
>>>>>> previously modified, typically for text relocations,
>>>>>> - FILE__WRITE: mmap/mprotect PROT_WRITE a shared file mapping,
>>>>>> - FILE__EXECUTE: mmap/mprotect PROT_EXEC a file mapping.
>>>>>>
>>>>>> (ignoring EXECSTACK and EXECHEAP here since they aren't really 
>>>>>> relevant to
>>>>>> this discussion)
>>>>>>
>>>>>> So if you want to ensure W^X, then you wouldn't allow EXECMEM for the
>>>>>> process, EXECMOD by the process to any file, and the combination 
>>>>>> of both
>>>>>> FILE__WRITE and FILE__EXECUTE by the process to any file.
>>>>>>
>>>>>> If the /dev/sgx/enclave mappings are MAP_SHARED and you aren't 
>>>>>> using an
>>>>>> anonymous inode, then I would expect that only the FILE__WRITE and
>>>>>> FILE__EXECUTE checks are relevant.
>>>>>
>>>>> Yep, I was just typing this up in a different thread:
>>>>>
>>>>> I think we may want to change the SGX API to alloc an anon inode 
>>>>> for each
>>>>> enclave instead of hanging every enclave off of the 
>>>>> /dev/sgx/enclave inode.
>>>>> Because /dev/sgx/enclave is NOT private, SELinux's 
>>>>> file_map_prot_check()
>>>>> will only require FILE__WRITE and FILE__EXECUTE to mprotect() 
>>>>> enclave VMAs
>>>>> to RWX.  Backing each enclave with an anon inode will make SELinux 
>>>>> treat
>>>>> EPC memory like anonymous mappings, which is what we want (I 
>>>>> think), e.g.
>>>>> making *any* EPC page executable will require PROCESS__EXECMEM (SGX is
>>>>> 64-bit only at this point, so SELinux will always have 
>>>>> default_noexec).
>>>> I don't think we want to require EXECMEM (or equivalently both 
>>>> FILE__WRITE and FILE__EXECUTE to /dev/sgx/enclave) for making any 
>>>> EPC page executable, only if the page is also writable or previously 
>>>> modified.  The intent is to prevent arbitrary code execution without 
>>>> EXECMEM (or FILE__WRITE|FILE__EXECUTE), while still allowing 
>>>> enclaves to be created without EXECMEM as long as the EPC page 
>>>> mapping is only ever mapped RX and its initial contents came from an 
>>>> unmodified file mapping that was PROT_EXEC (and hence already 
>>>> checked via FILE__EXECUTE).
>>>
>>> Also, just to be clear, there is nothing inherently better about 
>>> checking EXECMEM instead of checking both FILE__WRITE and 
>>> FILE__EXECUTE to the /dev/sgx/enclave inode, so I wouldn't switch to 
>>> using anon inodes for that reason.  Using anon inodes also 
>>> unfortunately disables SELinux inode-based checking since we no 
>>> longer have any useful inode information, so you'd lose out on 
>>> SELinux ioctl whitelisting on those enclave inodes if that matters.
>>
>> How can that work?  Unless the API changes fairly radically, users 
>> fundamentally need to both write and execute the enclave.  Some of it 
>> will be written only from already executable pages, and some privilege 
>> should be needed to execute any enclave page that was not loaded like 
>> this.
> 
> I'm not sure what the API is. Let's say they do something like this:
> 
> fd = open("/dev/sgx/enclave", O_RDONLY);
> addr = mmap(NULL, size, PROT_READ | PROT_EXEC, MAP_SHARED, fd, 0);
> stuff addr into ioctl args
> ioctl(fd, ENCLAVE_CREATE, &ioctlargs);
> ioctl(fd, ENCLAVE_ADD_PAGE, &ioctlargs);
> ioctl(fd, ENCLAVE_INIT, &ioctlargs);
> 
> The important points are that they do not open /dev/sgx/enclave with 
> write access (otherwise they will trigger FILE__WRITE at open time, and 
> later encounter FILE__EXECUTE as well during mmap, thereby requiring 
> both to be allowed to /dev/sgx/enclave), and that they do not request 
> PROT_WRITE to the resulting mapping (otherwise they will trigger 
> FILE__WRITE at mmap time).  Then only FILE__READ and FILE__EXECUTE are 
> required to /dev/sgx/enclave in policy.
> 
> If they switch to an anon inode, then any mmap PROT_EXEC of the opened 
> file will trigger an EXECMEM check, at least as currently implemented, 
> as we have no useful backing inode information.

FWIW, looking at the selftest for SGX in the patch series, they open 
/dev/sgx/enclave O_RDWR (probably not necessary?) and mmap the open file 
RWX.  If that is necessary then I'd rather it show up as FILE__WRITE and 
FILE__EXECUTE to /dev/sgx/enclave instead of EXECMEM, so that we can 
allow the process the ability to perform that mmap without allowing it 
to make other mappings WX.  So staying with the single /dev/sgx/enclave 
inode is better in that regard.
